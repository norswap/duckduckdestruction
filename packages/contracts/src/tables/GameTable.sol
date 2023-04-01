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

uint256 constant _tableId = uint256(bytes32(abi.encodePacked(bytes16(""), bytes16("GameTable"))));
uint256 constant GameTableTableId = _tableId;

struct GameTableData {
  address creator;
  uint16 round;
  uint16 alive;
  bytes20[] bots;
}

library GameTable {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](4);
    _schema[0] = SchemaType.ADDRESS;
    _schema[1] = SchemaType.UINT16;
    _schema[2] = SchemaType.UINT16;
    _schema[3] = SchemaType.BYTES20_ARRAY;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.UINT16;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](4);
    _fieldNames[0] = "creator";
    _fieldNames[1] = "round";
    _fieldNames[2] = "alive";
    _fieldNames[3] = "bots";
    return ("GameTable", _fieldNames);
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

  /** Get creator */
  function getCreator(uint16 gameID) internal view returns (address creator) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 0);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Get creator (using the specified store) */
  function getCreator(IStore _store, uint16 gameID) internal view returns (address creator) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 0);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Set creator */
  function setCreator(uint16 gameID, address creator) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.setField(_tableId, _primaryKeys, 0, abi.encodePacked((creator)));
  }

  /** Set creator (using the specified store) */
  function setCreator(IStore _store, uint16 gameID, address creator) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.setField(_tableId, _primaryKeys, 0, abi.encodePacked((creator)));
  }

  /** Get round */
  function getRound(uint16 gameID) internal view returns (uint16 round) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 1);
    return (uint16(Bytes.slice2(_blob, 0)));
  }

  /** Get round (using the specified store) */
  function getRound(IStore _store, uint16 gameID) internal view returns (uint16 round) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 1);
    return (uint16(Bytes.slice2(_blob, 0)));
  }

  /** Set round */
  function setRound(uint16 gameID, uint16 round) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.setField(_tableId, _primaryKeys, 1, abi.encodePacked((round)));
  }

  /** Set round (using the specified store) */
  function setRound(IStore _store, uint16 gameID, uint16 round) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.setField(_tableId, _primaryKeys, 1, abi.encodePacked((round)));
  }

  /** Get alive */
  function getAlive(uint16 gameID) internal view returns (uint16 alive) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 2);
    return (uint16(Bytes.slice2(_blob, 0)));
  }

  /** Get alive (using the specified store) */
  function getAlive(IStore _store, uint16 gameID) internal view returns (uint16 alive) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 2);
    return (uint16(Bytes.slice2(_blob, 0)));
  }

  /** Set alive */
  function setAlive(uint16 gameID, uint16 alive) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.setField(_tableId, _primaryKeys, 2, abi.encodePacked((alive)));
  }

  /** Set alive (using the specified store) */
  function setAlive(IStore _store, uint16 gameID, uint16 alive) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.setField(_tableId, _primaryKeys, 2, abi.encodePacked((alive)));
  }

  /** Get bots */
  function getBots(uint16 gameID) internal view returns (bytes20[] memory bots) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _primaryKeys, 3);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes20());
  }

  /** Get bots (using the specified store) */
  function getBots(IStore _store, uint16 gameID) internal view returns (bytes20[] memory bots) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = _store.getField(_tableId, _primaryKeys, 3);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes20());
  }

  /** Set bots */
  function setBots(uint16 gameID, bytes20[] memory bots) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.setField(_tableId, _primaryKeys, 3, EncodeArray.encode((bots)));
  }

  /** Set bots (using the specified store) */
  function setBots(IStore _store, uint16 gameID, bytes20[] memory bots) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.setField(_tableId, _primaryKeys, 3, EncodeArray.encode((bots)));
  }

  /** Push an element to bots */
  function pushBots(uint16 gameID, bytes20 _element) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.pushToField(_tableId, _primaryKeys, 3, abi.encodePacked((_element)));
  }

  /** Push an element to bots (using the specified store) */
  function pushBots(IStore _store, uint16 gameID, bytes20 _element) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.pushToField(_tableId, _primaryKeys, 3, abi.encodePacked((_element)));
  }

  /** Get the full data */
  function get(uint16 gameID) internal view returns (GameTableData memory _table) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _primaryKeys, getSchema());
    return decode(_blob);
  }

  /** Get the full data (using the specified store) */
  function get(IStore _store, uint16 gameID) internal view returns (GameTableData memory _table) {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    bytes memory _blob = _store.getRecord(_tableId, _primaryKeys, getSchema());
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(uint16 gameID, address creator, uint16 round, uint16 alive, bytes20[] memory bots) internal {
    bytes memory _data = encode(creator, round, alive, bots);

    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.setRecord(_tableId, _primaryKeys, _data);
  }

  /** Set the full data using individual values (using the specified store) */
  function set(
    IStore _store,
    uint16 gameID,
    address creator,
    uint16 round,
    uint16 alive,
    bytes20[] memory bots
  ) internal {
    bytes memory _data = encode(creator, round, alive, bots);

    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.setRecord(_tableId, _primaryKeys, _data);
  }

  /** Set the full data using the data struct */
  function set(uint16 gameID, GameTableData memory _table) internal {
    set(gameID, _table.creator, _table.round, _table.alive, _table.bots);
  }

  /** Set the full data using the data struct (using the specified store) */
  function set(IStore _store, uint16 gameID, GameTableData memory _table) internal {
    set(_store, gameID, _table.creator, _table.round, _table.alive, _table.bots);
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal view returns (GameTableData memory _table) {
    // 24 is the total byte length of static data
    PackedCounter _encodedLengths = PackedCounter.wrap(Bytes.slice32(_blob, 24));

    _table.creator = (address(Bytes.slice20(_blob, 0)));

    _table.round = (uint16(Bytes.slice2(_blob, 20)));

    _table.alive = (uint16(Bytes.slice2(_blob, 22)));

    uint256 _start;
    uint256 _end = 56;

    _start = _end;
    _end += _encodedLengths.atIndex(0);
    _table.bots = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes20());
  }

  /** Tightly pack full data using this table's schema */
  function encode(
    address creator,
    uint16 round,
    uint16 alive,
    bytes20[] memory bots
  ) internal view returns (bytes memory) {
    uint16[] memory _counters = new uint16[](1);
    _counters[0] = uint16(bots.length * 20);
    PackedCounter _encodedLengths = PackedCounterLib.pack(_counters);

    return abi.encodePacked(creator, round, alive, _encodedLengths.unwrap(), EncodeArray.encode((bots)));
  }

  /* Delete all data for given keys */
  function deleteRecord(uint16 gameID) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    StoreSwitch.deleteRecord(_tableId, _primaryKeys);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, uint16 gameID) internal {
    bytes32[] memory _primaryKeys = new bytes32[](1);
    _primaryKeys[0] = bytes32(uint256((gameID)));

    _store.deleteRecord(_tableId, _primaryKeys);
  }
}
