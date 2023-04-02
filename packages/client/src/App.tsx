import { GameBoard } from "./components/GameBoard";
import { useMUD } from "./MUDContext";
import { Has } from "@latticexyz/recs";
import { useEntityQuery, useComponentValue } from "@latticexyz/react";
import { SyncState } from "@latticexyz/network";
import "./index.css";
import { useEffect, useState } from "react";
import { GameState } from "./types"

export const App = () => {
  const {
    world,
    components: { LoadingState, GlobalTable, GameTable },
    network: { connectedAddress },
    singletonEntity,
    worldSend
  } = useMUD();

  const loadingState = useComponentValue(LoadingState, singletonEntity, {
    state: SyncState.CONNECTING,
    msg: "Connecting",
    percentage: 0
  });

  const [gameState, setGameState] = useState(GameState.NOT_STARTED);

  const create = async () => {
    const createTx = await worldSend("createGame", []);
    await createTx.wait();
  }

  const addBot = async (address: string, id: number) => {
      const startTx = await worldSend("addBot", [id, address]);
      await startTx.wait();
  }

  const start = async (id: number) => { 
      const startTx = await worldSend("startGame", [id]);
      await startTx.wait();
  }

  useEntityQuery([Has(GlobalTable)]).map(async (id) => {
    // await addBot("0x0E801D84Fa97b50751Dbf25036d067dCf18858bF", id);
    // await addBot("0x8f86403A4DE0BB5791fa46B8e795C547942fE4Cf", id);
  
    // await start(id);
  });

  return (
    <>
      {
        (
          gameState !== GameState.STARTED ? (
          <div
            className="intro"
            onClick={async () => {
              setGameState(GameState.STARTED)
            }}
            >
              <img src="textures/title.gif"/>
          </div>
        ) :
        <>
          <GameBoard/> 
        </>
        )
      }
    </>
  );
};

