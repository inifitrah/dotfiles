import { Variable, GLib } from "astal";
import { Astal, Gtk, Gdk, App } from "astal/gtk3";

// DynamicIsland component inspired by iOS
const DynamicIsland = (monitor: number) => {
  return (
    <window
      name={`dynamic-island-${monitor}`}
      className="dynamic-island-window"
      application={App}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.OVERLAY}
      anchor={Astal.WindowAnchor.TOP}
      layer={Astal.Layer.TOP}
    >
      <box className="dynamic-island" hpack={Gtk.Align.CENTER}>
        {/* Default state - pill shape */}
        <box className="dynamic-island-inner">
          <box className="dynamic-island-content">
            {/* Placeholder content - can be replaced with actual widgets */}
            <box className="dynamic-island-indicator" />
          </box>
        </box>
      </box>
    </window>
  );
};

export default DynamicIsland;
