// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";
import { IStoreHook } from "@latticexyz/store/src/IStore.sol";
import { IBaseWorld } from "@latticexyz/world/src/interfaces/IBaseWorld.sol";
import { ReversePositionTableHook } from "src/hooks/ReversePositionTableHook.sol";
import { ExampleBot } from "src/bots/ExampleBot.sol";
import { IWorld } from "src/world/IWorld.sol";

contract PostDeploy is Script {

  function run(address worldAddress) external {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    console.log("deployer address", address(this));
    console.log("world address", worldAddress);

    vm.startBroadcast(deployerPrivateKey);

    address hook = address(new ReversePositionTableHook());
    console.log("hook address", hook);

    // NOTE(norswap): This isn't a super intuitive or documented way of doing things, and might
    //   change in the future. In particular, `IWorld.registerStoreHook` seems buggy and might get
    //   fixed. Or maybe IWorld will include `registerHook`.
    IBaseWorld baseWorld = IBaseWorld(worldAddress);
    baseWorld.registerHook("", "position", hook);
    IWorld world = IWorld(worldAddress);
    world.grantAccess("", "reversePosition", hook);

    uint256 length = 6;
    address[] memory bots = new address[](length);
    for (uint256 i = 0; i < length; i++) {
      bots[i] = address(new ExampleBot());
      console.log("ExampleBot address", bots[i]);
    }

    vm.stopBroadcast();
  }
}
