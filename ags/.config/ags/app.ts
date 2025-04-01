import { App } from "astal/gtk3";
import style from "./style.scss";
import Bar from "./src/components/Bar";
import Calendar from "./src/components/Calendar";
import Notch from "./src/components/Notch";
import AudioSlider from "./src/components/AudioSlider";

App.start({
  // instanceName: "trah-shell",
  css: style,
  main() {
    App.get_monitors().map((monitor) => {
      Bar(monitor);
      Notch(monitor);
      AudioSlider(monitor);
      Calendar(monitor);
    });
  },
});
