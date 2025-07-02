import { Astal, Gtk, Gdk, App } from "astal/gtk3";
import { SysTray } from "./SysTray";
import { Wifi } from "./Wifi";
import { BatteryLevel } from "./Battery";
import { Clock } from "./Clock";
import { FocusedClient } from "./FocusedClient";
import Memory from "./Memory";
import Workspaces from "./Workspaces";

export default function Bar(monitor: Gdk.Monitor) {
  return (
    <window
      name={"Bar"}
      className="Bar"
      application={App}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START} className={"leftBar"}>
          <button
            onClick={() => {
              App.toggle_window("controll-center");
            }}
          >
            󰣇
          </button>
          <Workspaces gdkmonitor={monitor} />
          <FocusedClient />
        </box>
        <box className={"centerBar"} />
        <box hexpand halign={Gtk.Align.END} className={"rightBar"}>
          <Memory />
          <SysTray />
          <Wifi />
          <BatteryLevel />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
