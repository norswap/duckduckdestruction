import { useRef } from "react";
import { loadTexture, loadGeometry } from "../utils";
import { ThreeElements } from '@react-three/fiber';
import { Direction } from '../types';

export function Player(props: ThreeElements["mesh"] & { direction: Direction }) {
  const ref = useRef<THREE.Mesh>(null!);

  const geometry = loadGeometry("duck.gltf", "NormalDuck_Low_copy")

  const map = loadTexture(("4" + ".png"));

  const rotation = props.direction == Direction.UP ?  30 :
    props.direction == Direction.RIGHT ? -30 :
    props.direction == Direction.DOWN ? -60 :
    props.direction == Direction.LEFT ? -60 :
    0;

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
        Math.PI / 2,
        0,
        0
      ]}
    >
      <meshStandardMaterial map={map} />
    </mesh>
  );
}
