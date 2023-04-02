// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { PositionTable, PositionTableData } from "../tables/PositionTable.sol";
import { AttributeTable, AttributeTableData } from "../tables/AttributeTable.sol";
import { SystemPlus } from "../libraries/SystemPlus.sol";
import { LibMap } from "../libraries/LibMap.sol";
import { Direction } from "../Types.sol";
import "../Globals.sol";

// TODO access control

// TODO handle collisions
// node_modules/@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol

// TODO more dash directions?

// TODO: add blast damage radius

contract ActionSystem is SystemPlus {

    function encoded(AttributeTableData memory player) internal pure returns (bytes32 result) {
        assembly {
            result := mload(player)
        }
    }

    function hits(address bot, uint16 gameID, uint16 round, address target, uint16 radius)
            internal view returns(bool) {
        PositionTableData memory position = PositionTable.get(bot, gameID, round);
        PositionTableData memory targetPosition = PositionTable.get(target, gameID, round);
        return LibMap.distance(position, targetPosition) <= radius;
    }

    function punch(address bot, uint16 gameID, uint16 round, address target) public {
        AttributeTableData memory original = AttributeTable.get(bot, gameID, round);
        AttributeTableData memory player = original;
        if (hits(bot, gameID, round, target, 1)) player.health -= PUNCH_DAMAGE;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        if (encoded(player) != encoded(original)) AttributeTable.set(bot, gameID, round, player);
    }

    function shoot(address bot, uint16 gameID, uint16 round, address target) public {
        AttributeTableData memory player = AttributeTable.get(bot, gameID, round);
        if (player.ammo == 0) return; // out of ammo
        player.ammo--;
        if (hits(bot, gameID, round, target, SHOOT_RADIUS)) player.health -= SHOOT_DAMAGE;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        AttributeTable.set(bot, gameID, round, player);
    }

    function blast(address bot, uint16 gameID, uint16 round, address target) public {
        AttributeTableData memory player = AttributeTable.get(bot, gameID, round);
        if (player.charge != 0) return; // not charged
        if (player.rockets == 0) return; // out of rockets
        player.rockets--;
        player.charge = CHARGING_TIME;
        if (hits(bot, gameID, round, target, BLAST_RADIUS)) player.health -= BLAST_DAMAGE;
        AttributeTable.set(bot, gameID, round, player);
    }

    function charge(address bot, uint16 gameID, uint16 round) public {
        uint8 playerCharge = AttributeTable.getCharge(bot, gameID, round);
        if (playerCharge == 0) return; // already charged
        AttributeTable.setCharge(bot, gameID, round, playerCharge - 1);
    }

    function move(address bot, uint16 gameID, uint16 round, Direction direction) public {
        PositionTableData memory position = PositionTable.get(bot, gameID, round);
        unchecked {
            if (direction == Direction.DOWN) {
                position.y = (position.y - MOVE_DISTANCE) % MAP_HEIGHT;
            } else if (direction == Direction.UP) {
                position.y = (position.y + MOVE_DISTANCE) % MAP_HEIGHT;
            } else if (direction == Direction.LEFT) {
                position.x = (position.x - MOVE_DISTANCE) % MAP_WIDTH;
            } else if (direction == Direction.RIGHT) {
                position.x = (position.x + MOVE_DISTANCE) % MAP_WIDTH;
            }
        }
        PositionTable.set(bot, gameID, round, position);
        uint8 playerCharge = AttributeTable.getCharge(bot, gameID, round);
        if (playerCharge != CHARGING_TIME)
            AttributeTable.setCharge(bot, gameID, round, playerCharge + DISCHARGE_SPEED);
    }

    function dash(address bot, uint16 gameID, uint16 round, Direction direction) public {
        AttributeTableData memory player = AttributeTable.get(bot, gameID, round);
        uint16 last = player.lastDash;
        if (last + DASH_COOLDOWN > round && last != 0) return; // still on cooldown

        PositionTableData memory position = PositionTable.get(bot, gameID, round);
        unchecked {
            if (direction == Direction.DOWN) {
                position.y = (position.y - DASH_DISTANCE) % MAP_HEIGHT;
            } else if (direction == Direction.UP) {
                position.y = (position.y + DASH_DISTANCE) % MAP_HEIGHT;
            } else if (direction == Direction.LEFT) {
                position.x = (position.x - DASH_DISTANCE) % MAP_WIDTH;
            } else if (direction == Direction.RIGHT) {
                position.x = (position.x + DASH_DISTANCE) % MAP_WIDTH;
            }
        }
        PositionTable.set(bot, gameID, round, position);
        player.lastDash = round;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        AttributeTable.set(bot, gameID, round, player);
    }
}