import React, { useEffect, useState } from "react";
import * as THREE from "three";
import { useRef, useMemo } from "react";
import { Canvas, useThree } from "@react-three/fiber";
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import { useKeyboardMovement } from "../useKeyboardMovement";
import { EntityID, getComponentValue, getComponentValueStrict, Has, HasValue, isEntityType } from "@latticexyz/recs";
import { useMUD } from "../MUDContext";
import { OrbitControls, Effects, RoundedBox } from '@react-three/drei';
import { Player } from './Player';
import { Action } from './Action';
import { Tile } from './Tile';
import { makeSound, loadTexture } from '../utils';
import { ActionType } from '../types';
import { hexlify, hexZeroPad } from 'ethers/lib/utils';

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
      BotTable,
      PositionTable,
      //ReversePositionTable,
      AttributeTable,
      ActionTable,
      GameTable
    },
    singletonEntity
  } = useMUD();

  const botAddresses = useEntityQuery([Has(BotTable)])
    .map(entity => {
      const address = getComponentValue(BotTable, entity);
      return address;
    });

   const [roundIdx, setRoundIdx] = useState(0);
   const [gameIdx, setGameIdx] = useState(0);

    useEffect(() => {
      //Implementing the setInterval method
      const interval = setInterval(() => {
          if (roundIdx < 9) {
            setRoundIdx(roundIdx + 1);
          } else {
            setRoundIdx(0);

            if (gameIdx < 9) {
              setGameIdx(gameIdx + 1)
            } else {
              setGameIdx(0)
            }
          }

          console.log(roundIdx)
          console.log(gameIdx)
      }, 1500);

      //Clearing the interval
      return () => clearInterval(interval);
    }, [roundIdx]);

    const bots = botAddresses
      .map(({ bot }: any) => {
        const entity = hexlify(bot).padEnd(66, "0");
        const game = hexZeroPad(hexlify(0), 32);
        const round = hexZeroPad(hexlify(roundIdx), 32);
        const entityID = `${entity}:${game}:${round}`;

        const entityIdx = world.entityToIndex.get(entityID as any);

        const action = getComponentValue(ActionTable, entityIdx as any);
        const attributes = getComponentValue(AttributeTable, entityIdx as any);
        const position = getComponentValue(PositionTable, entityIdx as any);

        soundBoard["movement"].play();

        return {
          entity: bot,
          action,
          position,
          attributes
        }
      });

  //useEffect(() => {
  //  const interval = setInterval(() => {
  //    if (roundIdx == 9) {
  //      roundIdx = 0;
  //      updateBots(getBotstate(roundIdx));
  //    } else {
  //      setRound(roundIdx++);
  //    }

  //    console.log(roundIdx);
  //  }, 2000);

  //  return(() => clearInterval(interval))
  //});

  // Preload textures
  const textures = new Array(5).fill(0).map((_, i) => loadTexture((i == 0 ? 1 : i) + ".png"));

  const populate = (count: number) => new Array(count).fill(0).map((_, i) => i);

  const rows = useMemo(() => populate(50), []);
  const cols = useMemo(() => populate(50), []); 

  useThree(({ camera }) => {
    camera.position.set(0, 20, 0);
  });

  const { size, scene, camera } = useThree()
  const resolution = useMemo(() => new THREE.Vector2(size.width, size.height), [size]);

  useEffect(() => {
    soundBoard.soundtrack.play();
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
            
        {bots.map((p: any, i: number) => {
          return (
          <Player
            key={i}
            position={[p?.position.x, 0, p?.position.y]}
            attributes={p.attributes}
            color={(parseInt(p.entity) * 123456) % 16777215}
          />)
        })}
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
