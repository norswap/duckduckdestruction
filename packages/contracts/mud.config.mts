import { mudConfig, resolveTableId } from "@latticexyz/cli";

export default mudConfig({
  overrideSystems: {
    MoveSystem: {
      fileSelector: "move",
      openAccess: true,
    },
  },
  tables: {
    Round : {
      fileSelector: "round",
      primaryKeys: {},
      schema: {
        round: "uint16"
      }
    },
    PositionTable: {
      fileSelector: "position",
      schema: {
        x: "uint16",
        y: "uint16"
      },
    },
    PlayerTable: {
      fileSelector: "player",
      schema: {
        health: "uint16",
        ammo: "uint16",
        rockets: "uint16",
        lastDash: "uint16",
        charge: "uint8"
      }
    },
  },
  enums: {
    Direction: [ "LEFT", "RIGHT", "UP", "DOWN" ]
  },
  modules: [
    {
      name: "KeysWithValueModule",
      root: true,
      args: [resolveTableId("PositionTable")],
    },
  ],
});
