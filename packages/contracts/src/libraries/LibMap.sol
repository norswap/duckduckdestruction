// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { PositionTableData } from "../tables/PositionTable.sol";

library LibMap {
  function distance(PositionTableData memory from, PositionTableData memory to) internal pure returns (uint16) {
    uint16 deltaX = from.x > to.x ? from.x - to.x : to.x - from.x;
    uint16 deltaY = from.y > to.y ? from.y - to.y : to.y - from.y;
    return deltaX + deltaY;
  }
}
