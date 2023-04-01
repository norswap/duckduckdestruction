import React from "react";
import * as THREE from "three";
import { useRef } from "react";
import { Canvas, Color, ThreeElements, useThree, useLoader, useFrame } from "@react-three/fiber";
import { TextureLoader } from 'three/src/loaders/TextureLoader'
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import { useKeyboardMovement } from "../useKeyboardMovement";
import { EntityID, getComponentValueStrict, Has } from "@latticexyz/recs";
import { useMUD } from "../MUDContext";
import { OrbitControls } from '@react-three/drei';
import { Player } from './Player';
import { Tile } from './Tile';
import { makeSound } from '../utils';
import { Pfp } from './Pfp';

//  const address = connectedAddress.get();
//          <Pfp address={address}/>

const rows = new Array(25).fill(0).map((_, i) => i);
const cols = new Array(25).fill(0).map((_, i) => i);
let address;

const soundBoard = {
  movement: makeSound("movement"),
  hit: makeSound("hit"),
  death: makeSound("death")
};

function Scene() {
  const {
    world,
    components: { PositionTable, PlayerTable, Round },
    network: { connectedAddress },
  } = useMUD();

  address = connectedAddress.get();
  if (!address) throw new Error("Not connected");
  const playerEntityId = address as EntityID;
  const playerEntity = world.registerEntity({ id: playerEntityId });

  useKeyboardMovement();

  const playerPosition = useComponentValue(PositionTable, playerEntity);
  const playerStats = useComponentValue(PlayerTable, playerEntity);

  //console.log(playerStats);
  console.log(playerPosition);

  const otherPlayers = useEntityQuery([Has(PositionTable)])
    .filter((entity) => entity !== playerEntity)
    .map((entity) => {
      const position = getComponentValueStrict(PositionTable, entity);
      return {
        entity,
        position,
      };
    });

  useThree(({ camera }) => {
    camera.position.set( 20, 20, 20 );
    camera.rotation.order = 'YXZ';
    camera.rotation.y = - Math.PI / 4;
    camera.rotation.x = Math.atan( - 1 / Math.sqrt( 2 ) );
  });

  return (
    <group>
      <ambientLight />
      <pointLight position={[10, 10, 10]} />

      <group position={[0, -1.5, 0]}>
        {
          rows.map((x) => 
            cols.map(y => {
              console.log(x);
              console.log(playerPosition)

              return (
                <Tile position={{x, y}}/>
              )
          })
          )
        } 
      </group>

      {playerPosition ? (
        <Player position={[playerPosition.x, 0, playerPosition.y]}/>
      ) : null}
      {otherPlayers.map((p, i) => (
        <Player key={i} position={[p.position.x, 0, p.position.y]}
        />
      ))}
    </group>
  );
}

export const GameBoard = () => {
   const ref = useRef();

   return (
    <>
      <Canvas style={{ height: "100vh" }}>
        <OrbitControls
          autoRotate={true}
          target={[10, -20, 10]}
          keyPanSpeed={0}
          enablePan={false}
          enableRotate={false}
          ref={ref}/>
        <Scene/>
      </Canvas>
    </>
  );
};
