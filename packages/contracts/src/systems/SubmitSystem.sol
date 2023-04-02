// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { SystemPlus } from "../libraries/SystemPlus.sol";
import { GameTable } from "src/tables/GameTable.sol";
import { ActionTable, ActionTableData } from "src/tables/ActionTable.sol";
import { ActionType, Direction } from "src/Types.sol";

contract SubmitSystem is SystemPlus {

    error ActionAlreadySubmitted();
    error UnknownActionType();
    error UnknownDirection();
    error DirectionNotSpecified();
    error TargetNotSpecified();
    error TargetDoesNotExist();

    /**
     * Called by bots to submit an action. Superficially validates the arguments (e.g. verifies
     * that correct parameter are specified for each action type and that things are within range),
     * reverting otherwise. Game-state specifid validation is done by the other systems
     * (MoveSystem, AttackSystem, ...) and can still result in an ineffective action.
     */
    function submitAction(uint16 gameID, uint16 index, ActionTableData memory action) external {
        address bot = _msgSender();
        uint16 round = GameTable.getRound(gameID);
        ActionTableData memory old = ActionTable.get(bot, gameID, round);

        if (old.actionType != ActionType.NONE)
            revert ActionAlreadySubmitted();

        ActionType aType = action.actionType;

        if (aType > type(ActionType).max)
            revert UnknownActionType();
        if (action.direction > type(Direction).max)
            revert UnknownDirection();

        if (aType == ActionType.MOVE) {
            if (action.direction == Direction.NONE)
                revert DirectionNotSpecified();
        } else if (aType == ActionType.PUNCH || aType == ActionType.SHOOT || aType == ActionType.BLAST) {
            if (action.target == address(0))
                revert TargetNotSpecified();
            // TODO check existence of target in some table
        }

        ActionTable.set(bot, gameID, round, action);
    }
}
