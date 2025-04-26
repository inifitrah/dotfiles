import { Variable, GLib } from "astal";
import { Astal, Gtk, Gdk, App } from "astal/gtk3";

// DynamicIsland component inspired by iOS
const DynamicIsland = (monitor: Gdk.Monitor) => {
  const isHovered = Variable(false);
  isHovered.subscribe((value) => {
    console.log("isHovered", value);
  });
  return (
    <window
      name={`dynamic-island-${monitor}`}
      className="dynamic-island-window"
      application={App}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={Astal.WindowAnchor.TOP}
      layer={Astal.Layer.TOP}
      margin={-18}
    >
      <box className="dynamic-island" hpack={Gtk.Align.CENTER}>
        {/* Default state - pill shape */}
        <eventbox
          onHover={() => {
            isHovered.set(true);
          }}
          onHoverLost={() => {
            isHovered.set(false);
          }}
        >
          <box className="dynamic-island-inner">
            <box className="dynamic-island-content">
              {/* Placeholder content - can be replaced with actual widgets */}
              <box className="dynamic-island-indicator" />
              <box css={"margin-left: 10px"}>
                <label cursor={"pointer"} className="dynamic-island-label">
                  Dynamic Island
                </label>
              </box>
            </box>
          </box>
        </eventbox>
      </box>
    </window>
  );
};

export default DynamicIsland;
