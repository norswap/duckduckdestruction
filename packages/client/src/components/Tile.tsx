import { useRef, useState, useMemo } from "react";
import { ThreeElements } from '@react-three/fiber';
import { type Texture } from 'three';

export function Tile(props: ThreeElements["mesh"] & { position: { x: number, y: number } } & { texture: Texture }) {
  const ref = useRef<THREE.Mesh>(null!);

  return (
    <mesh
      ref={ref}
      position={[props.position.x, 0, props.position.y]}
      >
      <boxGeometry args={[1,  1, 1]} />
      <meshStandardMaterial map={props.texture} />
    </mesh>
  );
}