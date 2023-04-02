import { mudConfig, resolveTableId } from "@latticexyz/cli";

export default mudConfig({
  overrideSystems: {
    ActionSystem: {
      fileSelector: "ActionSystem",
      openAccess: true, // TODO should be false
      // accessList: ["GameSystem"]
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
        numBots: "uint16",
        alive: "uint16"
      }
    },
    BotTable: {
      fileSelector: "bot",
      primaryKeys: {
        index: "uint256"
      },
      schema: {
        bot: "address"
      }
    },
    PositionTable: {
      fileSelector: "position",
      primaryKeys: {
        bot: "address",
        game: "uint16",
        round: "uint16"
      },
      schema: {
        x: "uint16",
        y: "uint16"
      },
    },
    ReversePositionTable: {
      fileSelector: "reversePosition",
      primaryKeys: {
        x: "uint16",
        y: "uint16",
        game: "uint16",
        round: "uint16"
      },
      schema: {
        bot: "address"
      }
    },
    AttributeTable: {
      fileSelector: "attribute",
      primaryKeys: {
        bot: "address",
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
        bot: "address",
        game: "uint16",
        round: "uint16"
      },
      schema: {
        actionType: "ActionType",
        direction: "Direction",
        target: "address"
      }
    }
  },
  enums: {
    Direction: [ "NONE", "LEFT", "RIGHT", "UP", "DOWN" ],
    ActionType: [ "NONE", "MOVE", "DASH", "SHOOT", "BLAST", "PUNCH", "CHARGE" ],
  }
});