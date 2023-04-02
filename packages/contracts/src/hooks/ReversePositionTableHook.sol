// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IStoreHook } from "@latticexyz/store/src/IStore.sol";
import { PositionTable, PositionTableData, _tableId } from "src/tables/PositionTable.sol";
import { ReversePositionTable } from "src/tables/ReversePositionTable.sol";
import "../tables/PositionTable.sol";

contract ReversePositionTableHook is IStoreHook {

    function onSetRecord(uint256 table, bytes32[] memory key, bytes memory data) external override {
        if (table != _tableId) return;
        address bot = address(uint160(uint256(key[0])));
        uint16 gameID = uint16(uint256(key[1]));
        uint16 round = uint16(uint256(key[2]));
        // unregister old position
        PositionTableData memory position = PositionTable.get(bot, gameID, round);
        ReversePositionTable.deleteRecord(position.x, position.y, gameID, round);
        // register new position
        position = PositionTable.decode(data);
        ReversePositionTable.set(position.x, position.y, gameID, round, bot);
    }

    function onBeforeSetField(uint256 table, bytes32[] memory key, uint8 schemaIndex, bytes memory data) external override {
        if (table != _tableId) return;
        address bot = address(uint160(uint256(key[0])));
        uint16 gameID = uint16(uint256(key[1]));
        uint16 round = uint16(uint256(key[2]));
        // unregister old position
        PositionTableData memory position = PositionTable.get(bot, gameID, round);
        ReversePositionTable.deleteRecord(position.x, position.y, gameID, round);
        // register new position
        if (schemaIndex == 0)
            position.x = uint16(bytes2(data));
        else
            position.y = uint16(bytes2(data));
        ReversePositionTable.set(position.x, position.y, gameID, round, bot);
    }

    // Not needed.
    function onAfterSetField(uint256 table, bytes32[] memory key, uint8 schemaIndex, bytes memory data) external override {}

    // Not needed, position records are never deleted.
    function onDeleteRecord(uint256 table, bytes32[] memory key) external override {}
}