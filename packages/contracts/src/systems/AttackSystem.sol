// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { PositionTable, PositionTableData } from "../tables/PositionTable.sol";
import { PlayerTable, PlayerTableData } from "../tables/PlayerTable.sol";
import { SystemPlus } from "../libraries/SystemPlus.sol";
import { LibMap } from "../libraries/LibMap.sol";
import "../Globals.sol";

// TODO: add blast damage radius

library AttackLibrary {
    // Function you can use to decrease charge if you're not updating other parts of the player data.
    function discharge(bytes32 ID) public {
        uint8 playerCharge = PlayerTable.getCharge(ID);
        if (playerCharge == CHARGING_TIME) return;
        PlayerTable.setCharge(ID, playerCharge + DISCHARGE_SPEED);
    }
}

contract AttackSystem is SystemPlus {

    function encoded(PlayerTableData memory player) internal pure returns (bytes32 result) {
        assembly {
            result := mload(player)
        }
    }

    function hits(bytes32 ID, bytes32 targetID, uint16 radius) internal view returns(bool) {
        PositionTableData memory position = PositionTable.get(ID);
        PositionTableData memory targetPosition = PositionTable.get(targetID);
        return LibMap.distance(position, targetPosition) <= radius;
    }

    function punch(bytes32 targetID) public {
        bytes32 ID = senderID();
        PlayerTableData memory original = PlayerTable.get(ID);
        PlayerTableData memory player = original;
        if (hits(ID, targetID, 1)) player.health -= PUNCH_DAMAGE;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        if (encoded(player) != encoded(original)) PlayerTable.set(ID, player);
    }

    function shoot(bytes32 targetID) public {
        bytes32 ID = senderID();
        PlayerTableData memory player = PlayerTable.get(ID);
        if (player.ammo == 0) return; // out of ammo
        player.ammo--;
        if (hits(ID, targetID, SHOOT_RADIUS)) player.health -= SHOOT_DAMAGE;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        PlayerTable.set(ID, player);
    }

    function blast(bytes32 targetID) public {
        bytes32 ID = senderID();
        PlayerTableData memory player = PlayerTable.get(ID);
        if (player.charge != 0) return; // not charged
        if (player.rockets == 0) return; // out of rockets
        player.rockets--;
        player.charge = CHARGING_TIME;
        if (hits(ID, targetID, BLAST_RADIUS)) player.health -= BLAST_DAMAGE;
        PlayerTable.set(ID, player);
    }

    function charge() public {
        bytes32 ID = senderID();
        uint8 playerCharge = PlayerTable.getCharge(ID);
        if (playerCharge == 0) return; // already charged
        PlayerTable.setCharge(ID, playerCharge - 1);
    }
}