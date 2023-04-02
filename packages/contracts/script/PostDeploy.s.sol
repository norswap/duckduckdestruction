// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";
import { IStoreHook } from "@latticexyz/store/src/IStore.sol";
import { IBaseWorld } from "@latticexyz/world/src/interfaces/IBaseWorld.sol";
import { ReversePositionTableHook } from "src/hooks/ReversePositionTableHook.sol";
import { ExampleBot } from "src/bots/ExampleBot.sol";
import { IWorld } from "src/world/IWorld.sol";
import { GameTable } from "src/tables/GameTable.sol";

contract PostDeploy is Script {

  uint256 numBots = 16;
  uint256 rounds = 16;

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

    // NOTE(norswap): For running tests, comment below this line.

    address[] memory bots = new address[](numBots);
    for (uint256 i = 0; i < numBots; i++) {
      bots[i] = address(new ExampleBot());
      console.log("ExampleBot address", bots[i]);
    }

    uint16 gameID = world.createGame();
    for (uint256 i = 0; i < numBots; i++) {
      world.addBot(gameID, bots[i]);
    }
    world.startGame(gameID);
    for (uint256 i = 0; i < rounds; i++) {
      uint16 alive = GameTable.getAlive(world, gameID);
      console2.log("alive", alive);
      if (alive <= 1) break;
      world.nextRound(gameID);
    }
    console2.log("game over");
    vm.stopBroadcast();
  }
}
