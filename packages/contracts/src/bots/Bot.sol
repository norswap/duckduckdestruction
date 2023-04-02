// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { IWorld } from "src/world/IWorld.sol";
import { ActionTableData } from "src/tables/ActionTable.sol";
import { ActionType } from "src/Types.sol";

/**
 * Bots implement this interface to determine function to determine their behaviour (which action to
 * take for the current round).
 *
 * The world contract will call the `react` function of the bot with its current gameID, round
 * number, and the index of the bot (which it needs to pass when submitting its action). The bot can
 * in turn use the `world()` function to communicate with the world contract. In particular:F
 *
 * - The selection action must be submitted by calling the `submitAction` function of `Bot`.
 *
 * TODO
 */
abstract contract Bot {

    // Returns the sender cast with its World interface.
    function world() internal view returns (IWorld) {
        return IWorld(msg.sender);
    }

    function submitAction(uint16 gameID, uint16 index, ActionTableData memory action) internal {
        // NOTE(norswap): This is necessary because MUD codegen does not generate the correct
        // function selector when the function's signature includes a struct.
        world().call("", "SubmitSystem", abi.encodeWithSignature(
            "submitAction(uint16,uint16,(uint8,uint8,address))",
            gameID, index, action));
    }

    function react(uint16 gameID, uint16 round, uint16 index) external virtual;

    // TODO: Bots an currently see previous bots' action and the whole map.
    //
}
