import React, { useEffect } from "react";
import * as THREE from "three";
import { useRef, useMemo } from "react";
import { Canvas, Color, ThreeElements, useThree, useLoader, useFrame, extend } from "@react-three/fiber";
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import { useKeyboardMovement } from "../useKeyboardMovement";
import { EntityID, getComponentValueStrict, Has } from "@latticexyz/recs";
import { useMUD } from "../MUDContext";
import { OrbitControls, Effects } from '@react-three/drei';
import { Player } from './Player';
import { Tile } from './Tile';
import { makeSound } from '../utils';
import { Pfp } from './Pfp';
import { RenderPixelatedPass } from 'three-stdlib'
import { loadTexture } from '../utils';
import { P } from 'viem/dist/parseGwei-361e8a12';

extend({ RenderPixelatedPass });

// Init soundboard
const soundBoard = {
  soundtrack: makeSound("soundtrack", {
    loop: true
  }),
  movement: makeSound("movement"),
  hit: makeSound("hit"),
  death: makeSound("death")
};

function Scene() {
  // MUD 🔌
  const {
    world,
    components: { PositionTable, PlayerTable, GameTable, RoundTable },
    network: { connectedAddress },
    singletonEntity
  } = useMUD();

  const address = connectedAddress.get();
  if (!address) throw new Error("Not connected");
  const playerEntityId = address as EntityID;
  const playerEntity = world.registerEntity({ id: playerEntityId });

  //const round = useEntityQuery([Has(RoundTable)])
  //const game = useEntityQuery([Has(GameTable)])

  // Client controls
  useKeyboardMovement();

  const playerPosition = useComponentValue(PositionTable, playerEntity);

  const otherPlayers = useEntityQuery([Has(PositionTable)])
    .filter((entity) => entity !== playerEntity)
    .map((entity) => {
      const position = getComponentValueStrict(PositionTable, entity);
      return {
        entity,
        position,
      };
    });

  // Preload textures
  const textures = new Array(8).fill(0).map((_, i) => loadTexture((i == 0 ? 1 : i) + ".png"));

  // Floor layout
  const populate = (count: number) => new Array(25).fill(0).map((_, i) => i);

  const rows = useMemo(() => populate(25), []);
  const cols = useMemo(() => populate(25), []); 

  useThree(({ camera }) => {
    camera.position.set(20, 20, 20);
  });

  const { size, scene, camera } = useThree()
  const resolution = useMemo(() => new THREE.Vector2(size.width, size.height), [size]);

  useEffect(() => {
    soundBoard.soundtrack.play();
  }, [])

  return (
    <>
    <group>
      <ambientLight />
      <pointLight position={[10, 10, 10]} />

      <group position={[0, -1.5, 0]}>
        {
          rows.map((y) => 
            cols.map((x) => {
              return (
                <Tile
                  position={{x, y}}
                  texture={textures[Math.floor(Math.random() * (8 - 1 + 1) + 1)]
                  }/>
              )
          })
          )
        } 
      </group>

      <Player position={[2, 0, 2]}/>
      <Player position={[5, 0, 3]}/>
      <Player position={[15, 0, 5]}/>
      <Player position={[10, 0, 8]}/>

      {playerPosition ? (
        <Player position={[playerPosition.x, 0, playerPosition.y]}/>
      ) : null}
      {otherPlayers.map((p, i) => (
        <Player key={i} position={[p.position.x, 0, p.position.y]}/>
      ))}
    </group>

    <Effects>
      <renderPixelatedPass args={[
          resolution,
          1,
          scene,
          camera
        ]} />
    </Effects>
    </>
  );
}

export const GameBoard = () => {
   const ref = useRef();

   return (
    <>
      <Canvas style={{ height: "100vh" }}>
        <OrbitControls
          autoRotate={true}
          target={[25/2, -25/2, 25/2]}
          keyPanSpeed={0}
          enablePan={false}
          enableRotate={false}
          ref={ref}/>
        <Scene/>
     </Canvas>
    </>
  );
};
