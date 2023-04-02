// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Bot } from "./Bot.sol";
import { ActionTableData } from "src/tables/ActionTable.sol";
import { ActionType, Direction } from "src/Types.sol";

contract ExampleBot is Bot {

    function react(uint16 gameID, uint16 round, uint16 index) external override {
        uint256 random = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), this)));
        ActionTableData memory action = ActionTableData({
            actionType: ActionType.MOVE,
            direction: Direction((random % uint256(type(Direction).max) + 1)),
            target: address(0)
        });
        submitAction(gameID, index, action);
    }
}