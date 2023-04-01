// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { System } from "@latticexyz/world/src/System.sol";
import "../world/IWorld.sol";

abstract contract SystemPlus is System {

    // Make _msgSender() public so it can be called from libraries.
    function _msgSender_() public view returns (address sender) {
        return _msgSender();
    }

    // Make _world() public (and typed) so that other systems can be called.
    function world() internal view returns (IWorld) {
        return IWorld(_world());
    }

    function senderID() internal view returns (bytes32) {
        return bytes32(uint256(uint160((_msgSender()))));
    }
}