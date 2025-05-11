import { Brightness } from "./Brightness";
import { Volume } from "./Volume";

export const Sliders = () => {
  return (
    <box spacing={6} className="bordered" vertical>
      <Volume />
      <Brightness />
    </box>
  );
};
