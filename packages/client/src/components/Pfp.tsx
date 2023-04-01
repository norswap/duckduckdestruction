export const Pfp = (props: any & { address: string } & { x: number, y: number }) => {
  return (
    <div className="pfp">
        <img src="textures/4.png"/>
        <h1>{props.address + " | "} {props.x} {props.y} </h1>
    </div>
  );
};
