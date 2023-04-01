// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { AttackLibrary } from "../systems/AttackSystem.sol";
import { PositionTable, PositionTableData } from "../tables/PositionTable.sol";
import { PlayerTable, PlayerTableData } from "../tables/PlayerTable.sol";
import { RoundTable } from "../tables/RoundTable.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { SystemPlus } from "../libraries/SystemPlus.sol";
import { Direction } from "../Types.sol";
import "../Globals.sol";

// TODO new round should be a copy of last round
// TODO access control

// TODO handle collisions
// node_modules/@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol

// TODO more dash directions?

contract MoveSystem is SystemPlus {

  function move(bytes32 ID, uint16 gameID, uint16 round, Direction direction) public {
    PositionTableData memory position = PositionTable.get(ID, gameID, round);
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
    PositionTable.set(ID, gameID, round, position);
    // TODO this function is only used here, can inline it
    AttackLibrary.discharge(ID, round, gameID);
  }

  function dash(bytes32 ID, uint16 gameID, uint16 round, Direction direction) public {
    PlayerTableData memory player = PlayerTable.get(ID, gameID, round);
    uint16 last = player.lastDash;
    if (last + DASH_COOLDOWN > round && last != 0) return; // still on cooldown

    PositionTableData memory position = PositionTable.get(ID, gameID, round);
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
    PositionTable.set(ID, gameID, round, position);
    player.lastDash = round;
    if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
    PlayerTable.set(ID, gameID, round, player);
  }
}
