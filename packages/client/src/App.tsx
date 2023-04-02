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

  return (
    <>
      {
        (
          loadingState.state !== SyncState.LIVE ? (
          <div className="intro">
            <img src="loading.gif"/>
            Loading...
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

