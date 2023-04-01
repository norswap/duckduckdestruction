// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";

uint256 constant _tableId = uint256(bytes32(abi.encodePacked(bytes16(""), bytes16("round"))));
uint256 constant RoundTableTableId = _tableId;

library RoundTable {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.UINT16;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.UINT16;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](1);
    _fieldNames[0] = "round";
    return ("RoundTable", _fieldNames);
  }

  /** Register the table's schema */
  function registerSchema() internal {
    StoreSwitch.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Register the table's schema (using the specified store) */
  function registerSchema(IStore _store) internal {
    _store.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Set the table's metadata */
  function setMetadata() internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    StoreSwitch.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Set the table's metadata (using the specified store) */
  function setMetadata(IStore _store) internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    _store.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Get round */
  function get(uint16 game) internal view returns (uint16 round) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((game)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 0);
    return (uint16(Bytes.slice2(_blob, 0)));
  }

  /** Get round (using the specified store) */
  function get(IStore _store, uint16 game) internal view returns (uint16 round) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((game)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 0);
    return (uint16(Bytes.slice2(_blob, 0)));
  }

  /** Set round */
  function set(uint16 game, uint16 round) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((game)));

    StoreSwitch.setField(_tableId, _primaryKeys, 0, abi.encodePacked((round)));
  }

  /** Set round (using the specified store) */
  function set(IStore _store, uint16 game, uint16 round) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((game)));

    _store.setField(_tableId, _primaryKeys, 0, abi.encodePacked((round)));
  }

  /** Tightly pack full data using this table's schema */
  function encode(uint16 round) internal view returns (bytes memory) {
    return abi.encodePacked(round);
  }

  /* Delete all data for given keys */
  function deleteRecord(uint16 game) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((game)));

    StoreSwitch.deleteRecord(_tableId, _primaryKeys);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, uint16 game) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((game)));

    _store.deleteRecord(_tableId, _primaryKeys);
  }
}
