import { GLib } from "astal";
import { Gtk } from "astal/gtk3";

export default function StatusIndicator() {
  const whoami = GLib.get_user_name();

  return (
    <box>
      <label
        halign={Gtk.Align.CENTER}
        vexpand={true}
        hexpand={true}
        className="dynamic-island-whoami"
      >
        {whoami}
      </label>
    </box>
  );
}
