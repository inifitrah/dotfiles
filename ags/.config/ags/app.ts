import { App } from "astal/gtk3";
import style from "./style/style.scss";
import windows from "./windows";
import { ControllCenter } from "./src/components/bar/control-center/ControlCenter";

App.start({
  // instanceName: "trah-shell",
  css: style,
  main() {
    windows.map((win) => App.get_monitors().map((mon) => win(mon)));
    ControllCenter();
  },
});
