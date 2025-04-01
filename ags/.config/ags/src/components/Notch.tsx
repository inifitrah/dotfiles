import { App, Astal, Gdk } from "astal/gtk3";

export default function Notch(monitor: Gdk.Monitor) {
  const anchor = Astal.WindowAnchor.TOP;

  return (
    <window
      name="notch"
      visible={false}
      // monitor={0}
      gdkmonitor={monitor}
      application={App}
      anchor={anchor}
    >
      <box>
        <label label={"test"} />
      </box>
    </window>
  );
}
