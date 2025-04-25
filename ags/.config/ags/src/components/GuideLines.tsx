import { Astal, Gdk, Gtk } from "astal/gtk3";
import { Variable } from "astal";
import { bind } from "astal/binding";
import Cairo from "gi://cairo";

// Standard phone dimensions (can be customized)
const PHONE_WIDTH = 375; // iPhone X width (px)
const PHONE_HEIGHT = 900; // iPhone X height (px)

function PhoneGuideLines() {
  // Variable to track if guidelines are visible
  const isVisible = Variable<boolean>(true);

  const toggleVisibility = () => {
    isVisible.set(!isVisible.get());
  };

  return (
    <box className="phone-guide-container">
      <revealer transition_type="slide_down" reveal_child={bind(isVisible)}>
        <box
          className="phone-frame"
          width_request={PHONE_WIDTH}
          height_request={PHONE_HEIGHT}
        />
      </revealer>
      <button
        className="toggle-button"
        onClick={toggleVisibility}
        tooltipText="Toggle Guide Visibility"
      >
        <label label={bind(isVisible).as((v) => (v ? "👁️" : "👁️‍🗨️"))} />
      </button>
    </box>
  );
}

export default (monitor: Gdk.Monitor) => (
  <window
    gdkmonitor={monitor}
    name="guidelines"
    namespace="guidelines"
    className="guidelines"
    layer={Astal.Layer.BACKGROUND}
    margin={50}
    anchor={Astal.WindowAnchor.RIGHT}
    passThrough={true}
    exclusivity="ignore"
    setup={(self) => {
      // Set window to be fully transparent to inputs
      self.set_accept_focus(false);
      self.set_input_region(null);

      // Make the window clickable only on the toggle button
      const container = self.get_child();
      const toggleBtn = container.get_children()[1];

      if (toggleBtn instanceof Gtk.Button) {
        // Move button to a fixed position that doesn't interfere
        toggleBtn.set_property("halign", Gtk.Align.END);
        toggleBtn.set_property("valign", Gtk.Align.END);

        // Make only the button clickable
        toggleBtn.connect("realize", () => {
          toggleBtn.add_events(
            Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK
          );
        });

        toggleBtn.connect("enter-notify-event", () => {
          const alloc = toggleBtn.get_allocation();
          const region = new Cairo.Region();
          region.union_rectangle({
            x: alloc.x,
            y: alloc.y,
            width: alloc.width,
            height: alloc.height,
          });
          self.input_shape_combine_region(region);
          return false;
        });

        toggleBtn.connect("leave-notify-event", () => {
          // Reset to fully pass-through
          self.set_input_region(null);
          return false;
        });
      }
    }}
    child={PhoneGuideLines()}
  />
);
