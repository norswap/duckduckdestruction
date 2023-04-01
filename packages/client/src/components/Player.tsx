import { useRef } from "react";
import { loadTexture, loadGeometry } from "../utils";
import { ThreeElements } from '@react-three/fiber';

export function Player(props: ThreeElements["mesh"]) {
  const ref = useRef<THREE.Mesh>(null!);

  const geometry = loadGeometry("duck.gltf", "NormalDuck_Low_copy")

  const map = loadTexture(("4" + ".png"));

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
      rotation={[Math.PI / 2, 0, 0]}
    >
      <meshStandardMaterial map={map} />
    </mesh>
  );
}
