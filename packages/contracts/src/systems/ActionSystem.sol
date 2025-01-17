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

    function encoded(AttributeTableData memory attributes) internal pure returns (bytes32 result) {
        assembly {
            result := mload(attributes)
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
        AttributeTableData memory attributes = original;
        if (hits(bot, gameID, round, target, 1)) attributes.health -= PUNCH_DAMAGE;
        if (attributes.charge != CHARGING_TIME) attributes.charge += DISCHARGE_SPEED;
        if (encoded(attributes) != encoded(original)) AttributeTable.set(bot, gameID, round, attributes);
    }

    function shoot(address bot, uint16 gameID, uint16 round, address target) public {
        AttributeTableData memory attributes = AttributeTable.get(bot, gameID, round);
        if (attributes.ammo == 0) return; // out of ammo
        attributes.ammo--;
        if (hits(bot, gameID, round, target, SHOOT_RADIUS)) attributes.health -= SHOOT_DAMAGE;
        if (attributes.charge != CHARGING_TIME) attributes.charge += DISCHARGE_SPEED;
        AttributeTable.set(bot, gameID, round, attributes);
    }

    function blast(address bot, uint16 gameID, uint16 round, address target) public {
        AttributeTableData memory attributes = AttributeTable.get(bot, gameID, round);
        if (attributes.charge != 0) return; // not charged
        if (attributes.rockets == 0) return; // out of rockets
        attributes.rockets--;
        attributes.charge = CHARGING_TIME;
        if (hits(bot, gameID, round, target, BLAST_RADIUS)) attributes.health -= BLAST_DAMAGE;
        AttributeTable.set(bot, gameID, round, attributes);
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
        AttributeTableData memory attributes = AttributeTable.get(bot, gameID, round);
        uint16 last = attributes.lastDash;
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
        attributes.lastDash = round;
        if (attributes.charge != CHARGING_TIME) attributes.charge += DISCHARGE_SPEED;
        AttributeTable.set(bot, gameID, round, attributes);
    }
}