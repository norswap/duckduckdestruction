import { GameBoard } from "./components/GameBoard";
import { useMUD } from './MUDContext';
import { useComponentValue } from '@latticexyz/react';
import { SyncState } from '@latticexyz/network';
import "./index.css";

export const App = () => {
  const {
    world,
    components: { LoadingState },
    network: { connectedAddress },
    singletonEntity
  } = useMUD();

  const loadingState = useComponentValue(LoadingState, singletonEntity, {
    state: SyncState.CONNECTING,
    msg: "Connecting",
    percentage: 0,
  });

  return (
    <>
      {
        loadingState?.state !== SyncState.LIVE ? (
          <div className="loading">Loading...</div>
        ) :
        <>
          <GameBoard/> 
        </>
      }
    </>
  );
};
