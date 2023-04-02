import React, { useEffect } from "react";
import * as THREE from "three";
import { useRef, useMemo } from "react";
import { Canvas, useThree, useFrame } from "@react-three/fiber";
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import { useKeyboardMovement } from "../useKeyboardMovement";
import { EntityID, getComponentValueStrict, Has } from "@latticexyz/recs";
import { useMUD } from "../MUDContext";
import { OrbitControls, Effects } from '@react-three/drei';
import { Player } from './Player';
import { Action } from './Action';
import { Tile } from './Tile';
import { makeSound, loadTexture } from '../utils';
import { ActionType } from '../types';

// Init soundboard
const soundBoard = {
  soundtrack: makeSound("soundtrack", {
    loop: true
  }),
  movement: makeSound("movement"),
  hit: makeSound("hit"),
  death: makeSound("death")
};

const FPOV = false;

function Scene() {
  // MUD 🔌
  const {
    world,
    components: {
      PositionTable,
      ReversePositionTable,
      AttributeTable,
      ActionTable 
    },
    singletonEntity
  } = useMUD();

  //const players = useEntityQuery([Has(PositionTable)])
  //  .map((entity, i) => {
  //    const position = getComponentValueStrict(PositionTable, entity);

  //    return {
  //      position,
  //      attributes: {},
  //      state: {}
  //    };
  //  });

  //const actions = useEntityQuery([Has(ActionTable)])
  //  .map((action, i) => {
  //    //console.log(action);

  //    //const Action = 0;

  //    //switch (Action) {
  //    //  case ActionType.PUNCH:
  //    //  break;

  //    //  case ActionType.SHOOT:
        // teleport
  //    //  break;

  //    //  case ActionType.CHARGE:
  //    //  break;

  //    //  case ActionType.BLAST:
  //    //  break;

  //    //  case ActionType.MOVE:
  //    //  break;

  //    //  case ActionType.DASH:
  //    //  break;
  //    //}
  //  });

  // 🕛
  //useFrame((state) => {
  //  const time = state.clock.getElapsedTime();

  //  //actions.forEach(action => { });
  //});

  // Preload textures
  const textures = new Array(8).fill(0).map((_, i) => loadTexture((i == 0 ? 1 : i) + ".png"));

  const populate = (count: number) => new Array(count).fill(0).map((_, i) => i);

  const rows = useMemo(() => populate(50), []);
  const cols = useMemo(() => populate(50), []); 

  useThree(({ camera }) => {
    camera.position.set(0, 20, 0);
  });

  const { size, scene, camera } = useThree()
  const resolution = useMemo(() => new THREE.Vector2(size.width, size.height), [size]);

  useEffect(() => {
    //soundBoard.soundtrack.play();
  }, [])

  return (
    <>
      <group>
        <ambientLight intensity={0.75}/>
        <pointLight position={[25, 10, 25]} />

        <group position={[0, -1.5, 0]}>
          {
            rows.map((y) =>
              cols.map((x) => {
                return (
                  <Tile
                    position={{ x, y }}
                    texture={textures[Math.floor(Math.random() * (8 - 1 + 1) + 1)]
                    } />
                )
              })
            )
          }
        </group>

        {players.map((p, i) => (
          <Player
            key={i}
            position={[p.position.x, 0, p.position.y]}
            state={p.state}
            attributes={p.attributes}
            color={(parseInt(world.entities[p.entity]) * 123456) % 16777215}
            />
        ))}

        {actions.map((a, i) => (
          <Action type={0}/>
        ))}
      </group>
    </>
  );
}

export const GameBoard = () => {
  const ref = useRef();

  return (
    <>
      <Canvas style={{ height: "100vh" }}>
        {(!FPOV) ? 
        (<OrbitControls
          autoRotate={true}
          target={[25, -25, 25]}
          keyPanSpeed={0}
          enablePan={true}
          enableRotate={true}
          ref={ref}/>
        )
        :
        ""
        }
        <Scene/>
     </Canvas>
    </>
  );
};
