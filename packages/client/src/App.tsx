import { GameBoard } from "./components/GameBoard";
import { useMUD } from './MUDContext';
import { useComponentValue } from '@latticexyz/react';
import { SyncState } from '@latticexyz/network';
import "./index.css";
import { Intro } from './components/Intro';
import { useState } from 'react';

export const App = () => {
  const {
    world,
    components: { LoadingState },
    network: { connectedAddress },
    singletonEntity,
    worldSend
  } = useMUD();

  let gameID = 1; 
  let [started, setStarted] = useState(false);

  const loadingState = useComponentValue(LoadingState, singletonEntity, {
    state: SyncState.CONNECTING,
    msg: "Connecting",
    percentage: 0
  });

  const create = async () => {
    const txResult = await worldSend("createGame", []);

    const res = await txResult.wait();

    if (res.from.toLowerCase() == connectedAddress.get()?.toLocaleLowerCase()) {
      return res.logs[0].data;
    }
  }

  const start = async () => {
    setStarted(true);

    if (!!gameID ) {
      await create();
    }

    if (!!gameID) {
      const txResult = await worldSend("startGame", [gameID]);

      console.log(txResult)
    } else {
      alert("Game neeeds to be created first...");
    }
  }
 
  return (
    <>
      {
        (
          !started ? (
          <div
            className="intro"
            onClick={(loadingState?.state == SyncState.LIVE) ? start : () => {
              alert("Loading...")
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

