import { Astal, Gtk, Gdk, App } from "astal/gtk3";
import { SysTray } from "./SysTray";
import { Wifi } from "./Wifi";
import { BatteryLevel } from "./Battery";
import { Clock } from "./Clock";
import { FocusedClient } from "./FocusedClient";
import Memory from "./Memory";
import Workspacess from "./Workspacess";

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
          <button
            onClick={() => {
              App.toggle_window("controll-center");
            }}
          >
            󰣇
          </button>
          <Workspacess gdkmonitor={monitor} />
          <FocusedClient />
        </box>
        <box />
        <box hexpand halign={Gtk.Align.END}>
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
