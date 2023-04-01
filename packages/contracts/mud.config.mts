import { mudConfig, resolveTableId } from "@latticexyz/cli";

export default mudConfig({
  overrideSystems: {
    MoveSystem: {
      fileSelector: "move",
      openAccess: true,
    },
  },
  tables: {
    GlobalTable: {
      primaryKeys: {},
      schema: {
        nextGameID: "uint16"
      }
    },
    GameTable: {
      primaryKeys: {
        gameID: "uint16",
      },
      schema: {
        creator: "address",
        round: "uint16",
        alive: "uint16",
        bots: "bytes20[]"
      }
    },
    RoundTable : {
      fileSelector: "round",
      primaryKeys: {
        game: "uint16",
      },
      schema: {
        round: "uint16"
      }
    },
    PositionTable: {
      fileSelector: "position",
      primaryKeys: {
        player: "bytes32",
        game: "uint16",
        round: "uint16"
      },
      schema: {
        x: "uint16",
        y: "uint16"
      },
    },
    PlayerTable: {
      fileSelector: "player",
      primaryKeys: {
        player: "bytes32",
        game: "uint16",
        round: "uint16"
      },
      schema: {
        health: "uint16",
        ammo: "uint16",
        rockets: "uint16",
        lastDash: "uint16",
        charge: "uint8"
      }
    },
    ActionTable: {
      fileSelector: "action",
      primaryKeys: {
        player: "bytes32",
        game: "uint16",
        round: "uint16"
      },
      schema: {
        actionType: "ActionType",
        direction: "Direction",
        targetID: "bytes32"
      }
    }
  },
  enums: {
    Direction: [ "NONE", "LEFT", "RIGHT", "UP", "DOWN" ],
    ActionType: [ "NONE", "MOVE", "DASH", "SHOOT", "BLAST", "PUNCH", "CHARGE" ],
  },
  modules: [
    {
      name: "KeysWithValueModule",
      root: true,
      args: [resolveTableId("PositionTable")],
    },
  ],
});
