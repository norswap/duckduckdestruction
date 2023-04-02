import { ThreeElements } from '@react-three/fiber';
import { ActionType } from '../types'

export const Action = (props: ThreeElements["mesh"] & { type: ActionType }) => {
    return (
        <mesh
          //position={[props.position.x, 0.25, props.position.y]}
        >
        <sphereGeometry args={[0.5, 24, 8]}/>
        <meshStandardMaterial color="red"/>
      </mesh>
    )
}