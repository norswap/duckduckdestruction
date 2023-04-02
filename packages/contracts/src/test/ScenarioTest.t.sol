// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import { MudV2Test } from "@latticexyz/std-contracts/src/test/MudV2Test.t.sol";
import { IBaseWorld } from "@latticexyz/world/src/interfaces/IBaseWorld.sol";
import { IWorld } from "src/world/IWorld.sol";
import { ReversePositionTableHook } from "src/hooks/ReversePositionTableHook.sol";
import { ExampleBot } from "src/bots/ExampleBot.sol";

contract ScenarioTest is MudV2Test {
    IWorld world;
    uint256 length = 6;
    address[] bots = new address[](length);

    function setUp() public override {
        super.setUp();
        address deployer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.startPrank(deployer);
        world = IWorld(worldAddress);
        address hook = address(new ReversePositionTableHook());
        console.log("hook address", hook);

        // NOTE(norswap): This isn't a super intuitive or documented way of doing things, and might
        //   change in the future. In particular, `IWorld.registerStoreHook` seems buggy and might get
        //   fixed. Or maybe IWorld will include `registerHook`.
        IBaseWorld baseWorld = IBaseWorld(worldAddress);
        baseWorld.registerHook("", "position", hook);
        world.grantAccess("", "reversePosition", hook);

        for (uint256 i = 0; i < length; i++) {
            bots[i] = address(new ExampleBot());
            // TODO not needed
            world.grantAccess("", bots[i]);
            world.grantAccess("", "SubmitSystem", bots[i]);
            console.log("ExampleBot address", bots[i]);
        }
        vm.stopPrank();
    }

    function testRounds() public {
        uint256 rounds = 10;
        uint16 gameID = world.createGame();
        for (uint256 i = 0; i < length; i++) {
            world.addBot(gameID, bots[i]);
        }
        world.startGame(gameID);
        for (uint256 i = 0; i < rounds; i++) {
            world.nextRound(gameID);
        }
    }
}
