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
<<<<<<< HEAD
    function discharge(bytes32 ID) internal {
        uint8 playerCharge = PlayerTable.getCharge(ID);
=======
    function discharge(bytes32 ID, uint16 gameID, uint16 round) internal {
        uint8 playerCharge = PlayerTable.getCharge(ID, gameID, round);
>>>>>>> 5e7932a74dda6feb72d71ed97fb188324e1a4db2
        if (playerCharge == CHARGING_TIME) return;
        PlayerTable.setCharge(ID, gameID, round, playerCharge + DISCHARGE_SPEED);
    }
}

contract AttackSystem is SystemPlus {

    function encoded(PlayerTableData memory player) internal pure returns (bytes32 result) {
        assembly {
            result := mload(player)
        }
    }

    function hits(bytes32 ID, uint16 gameID, uint16 round, bytes32 targetID, uint16 radius)
            internal view returns(bool) {
        PositionTableData memory position = PositionTable.get(ID, gameID, round);
        PositionTableData memory targetPosition = PositionTable.get(targetID, gameID, round);
        return LibMap.distance(position, targetPosition) <= radius;
    }

    function punch(bytes32 ID, uint16 gameID, uint16 round, bytes32 targetID) public {
        PlayerTableData memory original = PlayerTable.get(ID, gameID, round);
        PlayerTableData memory player = original;
        if (hits(ID, gameID, round, targetID, 1)) player.health -= PUNCH_DAMAGE;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        if (encoded(player) != encoded(original)) PlayerTable.set(ID, gameID, round, player);
    }

    function shoot(bytes32 ID, uint16 gameID, uint16 round, bytes32 targetID) public {
        PlayerTableData memory player = PlayerTable.get(ID, gameID, round);
        if (player.ammo == 0) return; // out of ammo
        player.ammo--;
        if (hits(ID, gameID, round, targetID, SHOOT_RADIUS)) player.health -= SHOOT_DAMAGE;
        if (player.charge != CHARGING_TIME) player.charge += DISCHARGE_SPEED;
        PlayerTable.set(ID, gameID, round, player);
    }

    function blast(bytes32 ID, uint16 gameID, uint16 round, bytes32 targetID) public {
        PlayerTableData memory player = PlayerTable.get(ID, gameID, round);
        if (player.charge != 0) return; // not charged
        if (player.rockets == 0) return; // out of rockets
        player.rockets--;
        player.charge = CHARGING_TIME;
        if (hits(ID, gameID, round, targetID, BLAST_RADIUS)) player.health -= BLAST_DAMAGE;
        PlayerTable.set(ID, gameID, round, player);
    }

    function charge(bytes32 ID, uint16 gameID, uint16 round) public {
        uint8 playerCharge = PlayerTable.getCharge(ID, gameID, round);
        if (playerCharge == 0) return; // already charged
        PlayerTable.setCharge(ID, gameID, round, playerCharge - 1);
    }
}
