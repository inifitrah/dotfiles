import { Astal, Gtk, Gdk, App } from "astal/gtk3";
import { SysTray } from "./SysTray";
import { Wifi } from "./Wifi";
import { BatteryLevel } from "./Battery";
import { Clock } from "./Clock";
import { Workspaces } from "./Workspaces";
import { FocusedClient } from "./FocusedClient";

export default function Bar(monitor: Gdk.Monitor) {
  return (
    <window
      name={"Bar"}
      className="Bar"
      application={App}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Workspaces />
          <FocusedClient />
        </box>
        <box />
        <box hexpand halign={Gtk.Align.END}>
          <SysTray />
          <Wifi />
          <BatteryLevel />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
