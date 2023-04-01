// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";
import { SystemPlus } from "src/libraries/SystemPlus.sol";
import { IWorld } from "src/world/IWorld.sol";
import { GlobalTable } from "src/tables/GlobalTable.sol";
import { GameTable } from "src/tables/GameTable.sol";
import { ActionTable, ActionTableData } from "src/tables/ActionTable.sol";
import { PositionTable, PositionTableData, _tableId as positionTableID } from "src/tables/PositionTable.sol";
import { PlayerTable, PlayerTableData } from "src/tables/PlayerTable.sol";
import { Bot } from "src/bots/Bot.sol";
import { ActionType, Direction } from "src/Types.sol";
import "src/Globals.sol";

error CreatorOnly();
error NotEnoughBots();
error TooManyBots();
error GameOver();

contract GameSystem is SystemPlus {

    function createGame() external returns(uint16 gameID) {
        gameID = GlobalTable.get();
        GlobalTable.set(gameID + 1);
    }

    function addBot(uint16 gameID, address bot) external {
        GameTable.pushBots(gameID, bytes20(bot));
    }

    function startGame(uint16 gameID) external {
        if (_msgSender() != GameTable.getCreator(gameID))
            revert CreatorOnly();

        bytes20[] memory bots = (GameTable.getBots(gameID));
        uint256 length = bots.length;
        if (length < MIN_BOTS)
            revert NotEnoughBots();
        if (length > MAX_BOTS)
            revert TooManyBots();

        GameTable.setAlive(gameID, uint16(length));
        bytes32 seed = blockhash(block.number - 1);

        for (uint256 i = 0; i < length; i++) {
            // initialize positions to be random
            bytes32[] memory keys;
            PositionTableData memory position;
            do {
                uint16 x = uint16(uint256(seed) % MAP_HEIGHT);
                seed = keccak256(abi.encodePacked(seed));
                uint16 y = uint16(uint256(seed) % MAP_WIDTH);
                seed = keccak256(abi.encodePacked(seed));
                position = PositionTableData(x, y);
                keys = getKeysWithValue(positionTableID, PositionTable.encode(position.x, position.y));
            } while (keys[0] != 0x0); // avoid collisions
            // TODO switch keys to be addresses
            PositionTable.set(bytes32(bots[i]), gameID, 0, position);

            // initialize bot data
            PlayerTable.set(bytes32(bots[i]), gameID, 0,
                INITIAL_HEALTH, INITIAL_AMMO, INITIAL_ROCKETS, 0 /* lastDash */, CHARGING_TIME);
        }
    }

    function nextRound(uint16 gameID) external {
        uint16 round = GameTable.getRound(gameID);

        if (GameTable.getAlive(gameID) <= 1)
            revert GameOver();

        bytes20[] memory bots = (GameTable.getBots(gameID));
        uint256 length = bots.length;

        if (round > 0) {
            // Copy over the last round's position & player data.
            for (uint256 i = 0; i < length; i++) {
                bytes32 ID = bytes32(bots[i]);
                PositionTableData memory position = PositionTable.get(ID, gameID, round - 1);
                PositionTable.set(ID, gameID, round, position);
                PlayerTableData memory player = PlayerTable.get(ID, gameID, round - 1);
                PlayerTable.set(ID, gameID, round, player);
            }
        }

        // Populate the bots' action table for this round.
        // This must happen before applying the effect of actions: all bots take decision based
        // on the previous round's end state.
        for (uint256 i = 0; i < length; i++) {
            Bot bot = Bot(address(bots[i]));
            bot.getAction(gameID, round);
        }

        IWorld world = world();
        uint256 alive = 0;

        for (uint256 i = 0; i < length; i++) {
            bytes32 ID = bytes32(bots[i]);
            uint16 health = PlayerTable.getHealth(ID, gameID, round);
            if (health == 0) continue; // RIP
            alive++;
            ActionTableData memory action = ActionTable.get(ID, gameID, round);
            ActionType aType = action.actionType;
            if (aType == ActionType.MOVE) {
                world.move(ID, gameID, round, action.direction);
            } else if (aType == ActionType.DASH) {
                world.dash(ID, gameID, round, action.direction);
            } else if (aType == ActionType.SHOOT) {
                world.shoot(ID, gameID, round, action.targetID);
            } else if (aType == ActionType.PUNCH) {
                world.punch(ID, gameID, round, action.targetID);
            } else if (aType == ActionType.BLAST) {
                world.blast(ID, gameID, round, action.targetID);
            } else if (aType == ActionType.CHARGE) {
                world.charge(ID, gameID, round);
            }
            // if NONE (or not submitted, both 0), do nothing :)
        }

        unchecked {
            GameTable.setRound(gameID, round++);
        }
    }
}
