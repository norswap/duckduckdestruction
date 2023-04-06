// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Bot } from "./Bot.sol";
import { GameTable } from "src/tables/GameTable.sol";
import { BotTable } from "src/tables/BotTable.sol";
import { ActionTableData } from "src/tables/ActionTable.sol";
import { PositionTable, PositionTableData } from "src/tables/PositionTable.sol";
import { ActionType, Direction } from "src/Types.sol";
import { LibMap } from "src/libraries/LibMap.sol";
import "src/Globals.sol";

import { console2 } from "forge-std/console2.sol";

contract ExampleBot is Bot {

    bytes32 random = 0x0;

    function react(uint16 gameID, uint16 round, uint16 index) external override {

        if (random == 0x0) random = keccak256(abi.encodePacked(blockhash(block.number - 1), this));

        PositionTableData memory myPosition = PositionTable.get(world(), address(this), gameID, round);

        // If another bot is within range, shoot!
        uint256 numBots = GameTable.getNumBots(gameID);
        for (uint256 i = 0; i < numBots; i++) {
            address bot = BotTable.get(i);
            if (bot == address(this)) continue; // say no to self harm
            PositionTableData memory botPosition = PositionTable.get(world(), bot, gameID, round);
            uint16 distance = LibMap.distance(myPosition, botPosition);
            if (distance < SHOOT_RADIUS) {
                console2.log("shoot!");
                submitAction(gameID, index, ActionTableData({
                    actionType: ActionType.SHOOT,
                    direction: Direction.NONE,
                    target: bot
                }));
                return;
            }
        }

        // Otherwise take a random move.
        ActionTableData memory action = ActionTableData({
            actionType: ActionType.MOVE,
            direction: Direction((uint256(random) % uint256(type(Direction).max) + 1)),
            target: address(0)
        });
        random = keccak256(abi.encodePacked(random));
        submitAction(gameID, index, action);
    }
}