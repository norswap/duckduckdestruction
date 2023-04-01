// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { IWorld } from "../world/IWorld.sol";
import { ActionType } from "../Types.sol";

/**
 * Bots implement this interface to determine function to determine their behaviour (which action to
 * take for the current round).
 *
 * The world contract will call the `getAction` function of the bot with its current gameID. The
 * bot can in turn use the `world()` function to communicate with the world contract. In particular:
 *
 * - The selection action must be submitted by calling the `submitAction` function
 *   of the `ActionSystem` system.
 *
 * TODO
 */
abstract contract Bot {

    // Returns the sender cast with its World interface.
    function world() internal view returns (IWorld) {
        return IWorld(msg.sender);
    }

    function getAction(uint16 gameID, uint16 round) external virtual;
}
