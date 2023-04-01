import { useRef, useState } from "react";
import { loadTexture } from '../utils';
import { ThreeElements } from '@react-three/fiber';

export function Tile(props: ThreeElements["mesh"] & { position: { x: number, y: number } }) {
  const ref = useRef<THREE.Mesh>(null!);

  const textureName = Math.floor(Math.random() * (8 - 1 + 1) + 1);

  const texture = loadTexture(textureName + ".png");

  return (
    <mesh
      ref={ref}
      position={[props.position.x, 0, props.position.y]}
      >
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial
        map={texture}
      />
    </mesh>
  );
}