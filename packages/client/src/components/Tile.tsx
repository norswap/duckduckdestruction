import { useRef } from "react";
import { loadTexture } from '../utils';

export function Tile(props: ThreeElements["mesh"] & { position: Coordinates }) {
  const ref = useRef<THREE.Mesh>(null!);

  const texture = loadTexture("/floor/" + Math.floor(Math.random() * (3 - 1 + 1) + 1) + ".png");

    return (
    <mesh
      ref={ref}
      position={[props.position.x, 0, props.position.y]}
      >
      <boxGeometry args={[1, 2, 1]} />
      <meshStandardMaterial
        map={texture}
      />
    </mesh>
  );
}