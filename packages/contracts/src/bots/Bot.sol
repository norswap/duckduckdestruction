// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { IWorld } from "../world/IWorld.sol";
import { ActionType } from "../Types.sol";

import { console } from "forge-std/console.sol";

/**
 * Bots implement this interface to determine function to determine their behaviour (which action to
 * take for the current round).
 *
 * The world contract will call the `react` function of the bot with its current gameID, round
 * number, and the index of the bot (which it needs to pass when submitting its action). The bot can
 * in turn use the `world()` function to communicate with the world contract. In particular:F
 *
 * - The selection action must be submitted by calling the `submitAction` function
 *   from the `SubmitSystem` system on the `world()`.
 *
 * TODO
 */
abstract contract Bot {

    // Returns the sender cast with its World interface.
    function world() internal view returns (IWorld) {
        console.log("world", msg.sender);
        return IWorld(msg.sender);
    }

    function react(uint16 gameID, uint16 round, uint16 index) external virtual;
}
