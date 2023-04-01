// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { AttackLibrary } from "../systems/AttackSystem.sol";
import { PositionTable, PositionTableData } from "../tables/PositionTable.sol";
import { PlayerTable } from "../tables/PlayerTable.sol";
import { Round } from "../tables/Round.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { SystemPlus } from "../libraries/SystemPlus.sol";
import { Direction } from "../Types.sol";
import "../Globals.sol";

contract MoveSystem is SystemPlus {

  function move(Direction direction) public {
    bytes32 ID = senderID();
    PositionTableData memory position = PositionTable.get(ID);
    uint8 charge = PlayerTable.getCharge(ID);
    unchecked {
      if (direction == Direction.UP) {
        position.y++ % MAP_HEIGHT;
      } else if (direction == Direction.DOWN) {
        position.y-- % MAP_HEIGHT;
      } else if (direction == Direction.LEFT) {
        position.x-- % MAP_WIDTH;
      } else if (direction == Direction.RIGHT) {
        position.x++ % MAP_WIDTH;
      }
    }
    PositionTable.set(ID, position);
    AttackLibrary.discharge(ID);
  }

  function dash(Direction direction) public {
    bytes32 ID = senderID();
    uint16 lastDash = PlayerTable.getLastDash(ID);
    if (lastDash + DASH_COOLDOWN > Round.get()) return; // still on cooldown

    PositionTableData memory position = PositionTable.get(ID);
    unchecked {
      if (direction == Direction.UP) {
        position.y += DASH_DISTANCE % MAP_HEIGHT;
      } else if (direction == Direction.DOWN) {
        position.y -= DASH_DISTANCE % MAP_HEIGHT;
      } else if (direction == Direction.LEFT) {
        position.x -= DASH_DISTANCE % MAP_WIDTH;
      } else if (direction == Direction.RIGHT) {
        position.x += DASH_DISTANCE % MAP_WIDTH;
      }
    }
    PositionTable.set(ID, position);
    AttackLibrary.discharge(ID);
  }
}
