import { GLTFLoader  } from 'three/examples/jsm/loaders/GLTFLoader'
import { TextureLoader } from "three/src/loaders/TextureLoader";
import { useLoader } from "@react-three/fiber";
import { Howl, HowlOptions, Howler } from "howler";

export const loadTexture = (fileName: string) => useLoader(TextureLoader, "textures/" + fileName);

export const loadGeometry = (fileName: string, nodeName: string) => (useLoader(GLTFLoader, fileName)).nodes[nodeName].geometry;

export const makeSound = (state: string, options?: Omit<HowlOptions, "src">) => new Howl({
  src: [
    `sounds/${state}.wav`,
  ], 
    ...options
});
