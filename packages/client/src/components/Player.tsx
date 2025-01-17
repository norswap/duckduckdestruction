import { useRef } from "react";
import { loadTexture, loadGeometry } from "../utils";
import { ThreeElements } from '@react-three/fiber';
import { Direction } from '../types';
import { AnimationMixer } from 'three';
import { getComponentValue } from '@latticexyz/recs';
import { DEG2RAD } from 'three/src/math/MathUtils';

export function Player(props: ThreeElements["mesh"] & { direction: Direction } & { attributes: any } & { color: string }) {
  const ref = useRef<THREE.Mesh>(null!);
  const geometry = loadGeometry("duck.gltf", "NormalDuck_Low_copy");
  //const rotation = props.direction == Direction.RIGHT ? DEG2RAD * 90 :
  //  props.direction == Direction.DOWN ? DEG2RAD * 180 :
  //  props.direction == Direction.LEFT ? DEG2RAD * 270 :
  //  0;

  const rotation = DEG2RAD * 180;

  return (
    <mesh
      {...props}
      ref={ref}
      geometry={geometry}
      scale={[
        0.01,
        0.01,
        0.01
      ]}
      rotation={[
        (props?.attributes?.health == 0) ? 0 :  Math.PI / 2,
        0,
        rotation
      ]}
      onPointerOver={() => {}}
    >
      <meshStandardMaterial
        color={(props?.attributes?.health == 0) ? "#666" : props.color}
      />
    </mesh>
  );
}
