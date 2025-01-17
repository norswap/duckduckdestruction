// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { SystemPlus } from "src/libraries/SystemPlus.sol";
import { IWorld } from "src/world/IWorld.sol";
import { GlobalTable } from "src/tables/GlobalTable.sol";
import { GameTable } from "src/tables/GameTable.sol";
import { BotTable } from "src/tables/BotTable.sol";
import { ActionTable, ActionTableData } from "src/tables/ActionTable.sol";
import { PositionTable, PositionTableData } from "src/tables/PositionTable.sol";
import { ReversePositionTable } from "src/tables/ReversePositionTable.sol";
import { AttributeTable, AttributeTableData } from "src/tables/AttributeTable.sol";
import { Bot } from "src/bots/Bot.sol";
import { ActionType, Direction } from "src/Types.sol";
import "src/Globals.sol";

import { console2 } from "forge-std/console2.sol";
import "../bots/ExampleBot.sol";

    error CreatorOnly();
error LateJoin();
error NotEnoughBots();
error TooManyBots();
error GameOver();
error ItsBeenMuchTooLongIFeelItComingOn();

uint16 constant GAME_NOT_STARTED = type(uint16).max;

contract GameSystem is SystemPlus {

    function tmpDeployBots(uint16 gameID) external {
        for (uint256 i = 0; i < 6; i++) {
            address bot = address(new ExampleBot());
            addBot(gameID, bot);
        }
    }

    function createGame() external returns(uint16 gameID) {
        gameID = GlobalTable.get();
        GlobalTable.set(gameID + 1);
        // function set(uint16 gameID, uint16 id, address creator, uint16 round, uint16 numBots, uint16 alive) internal {
        GameTable.set(gameID, gameID, _msgSender(), GAME_NOT_STARTED, 0, 0);
    }

    // TODO revert to external after tmp functions are removed
    function addBot(uint16 gameID, address bot) public {
        // Creator-only for now.
        if (_msgSender() != GameTable.getCreator(gameID))
            revert CreatorOnly();
        if (GameTable.getRound(gameID) != GAME_NOT_STARTED)
            revert LateJoin();
        uint16 numBots = GameTable.getNumBots(gameID);
        BotTable.set(numBots, bot); // TODO should be indexed on the gameID
        GameTable.setNumBots(gameID, numBots + 1);
    }

    function startGame(uint16 gameID) external {
        if (_msgSender() != GameTable.getCreator(gameID))
            revert CreatorOnly();

        uint256 length = uint256(GameTable.getNumBots(gameID));
        if (length < MIN_BOTS)
            revert NotEnoughBots();
        if (length > MAX_BOTS)
            revert TooManyBots();

        GameTable.setRound(gameID, 0);
        GameTable.setAlive(gameID, uint16(length));

        bytes32 seed = blockhash(block.number - 1);

        for (uint256 i = 0; i < length; i++) {
            uint16 x;
            uint16 y;
            address other;
            do {
                x = uint16(uint256(seed) % MAP_HEIGHT);
                seed = keccak256(abi.encodePacked(seed));
                y = uint16(uint256(seed) % MAP_WIDTH);
                seed = keccak256(abi.encodePacked(seed));
                other = ReversePositionTable.get(x, y, gameID, 0);
            } while (other != address(0));

            address bot = BotTable.get(i);
            PositionTable.set(bot, gameID, 0, x, y);
            AttributeTable.set(bot, gameID, 0,
                INITIAL_HEALTH, INITIAL_AMMO, INITIAL_ROCKETS, 0 /* lastDash */, CHARGING_TIME);
        }
    }

    function nextRound(uint16 gameID) external {
        uint16 round = GameTable.getRound(gameID);

        if (round == MAX_ROUND)
            revert ItsBeenMuchTooLongIFeelItComingOn();

        if (GameTable.getAlive(gameID) <= 1)
            revert GameOver();

        uint256 numBots = uint256(GameTable.getNumBots(gameID));
        address[] memory bots = new address[](numBots);

        for (uint256 i = 0; i < numBots; i++) {
            address bot = BotTable.get(i);
            bots[i] = bot;
            // Copy over the last round's position & attributes.
            if (round > 0) {
                PositionTableData memory position = PositionTable.get(bot, gameID, round - 1);
                PositionTable.set(bot, gameID, round, position);
                AttributeTableData memory attributes = AttributeTable.get(bot, gameID, round - 1);
                AttributeTable.set(bot, gameID, round, attributes);
            }
        }

        // Populate the bots' action table for this round.
        // This must happen before applying the effect of actions: all bots take decision based
        // on the previous round's end state.
        for (uint256 i = 0; i < numBots; i++) {
            console2.log("reacting", bots[i], round, i);
            Bot(bots[i]).react(gameID, round, uint16(i));
        }

        IWorld world = world();
        uint256 alive = 0;

        for (uint256 i = 0; i < numBots; i++) {
            console2.log("enacting", round, i);
            address bot = bots[i];
            uint16 health = AttributeTable.getHealth(bot, gameID, round);
            if (health == 0) continue; // RIP
            alive++;
            ActionTableData memory action = ActionTable.get(bot, gameID, round);
            ActionType aType = action.actionType;
            if (aType == ActionType.MOVE) {
                console2.log("before move");
                world.move(bot, gameID, round, action.direction);
            } else if (aType == ActionType.DASH) {
                world.dash(bot, gameID, round, action.direction);
            } else if (aType == ActionType.SHOOT) {
                console2.log("before shoot");
                world.shoot(bot, gameID, round, action.target);
            } else if (aType == ActionType.PUNCH) {
                world.punch(bot, gameID, round, action.target);
            } else if (aType == ActionType.BLAST) {
                world.blast(bot, gameID, round, action.target);
            } else if (aType == ActionType.CHARGE) {
                world.charge(bot, gameID, round);
            }
            // if NONE (or not submitted, both 0), do nothing :)
        }

        unchecked {
            GameTable.setRound(gameID, round + 1);
            GameTable.setAlive(gameID, uint16(alive));
        }
    }
}
