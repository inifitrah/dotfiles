// @ts-nocheck
import { Variable, GLib, bind } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Notifd from "gi://AstalNotifd";

const LabelMe = ({ text }: string) => {
  console.log("LabelMe: ", text);
  return (
    <box>
      <label
        halign={Gtk.Align.CENTER}
        vexpand={true}
        hexpand={true}
        className="dynamic-island-hostname"
      >
        {text}
      </label>
    </box>
  );
};

// DynamicIsland component inspired by iOS
const DynamicIsland = (monitor: Gdk.Monitor) => {
  const isHovered = Variable(false);
  const activeNotification = Variable<Notification | null>(null);
  const isExpanded = Variable(false);
  let timeoutId: number | null = null;
  const whoami = GLib.get_user_name();

  const notifd = Notifd.get_default();

  // Subscribe to new notifications
  notifd.connect("notified", (_, id) => {
    const notification = notifd.get_notification(id);
    if (!notification) return;
    activeNotification.set(notification);
    isExpanded.set(true);
    // Cancel previous timeout if any
    if (timeoutId !== null) {
      console.log("timoutout cancelled");
      GLib.source_remove(timeoutId);
      timeoutId = null;
    }
    // Auto collapse after 1 second
    timeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 2000, () => {
      console.log("timeout triggered");
      isExpanded.set(false);
      console.log("expanded: ", isExpanded.get());
      // Hilangkan notifikasi ketika collapsed
      activeNotification.set(null);
      timeoutId = null;
      return GLib.SOURCE_REMOVE;
    });
  });

  // Clean up variables on destroy
  const onDestroy = () => {
    isHovered.drop();
    activeNotification.drop();
    isExpanded.drop();
    if (timeoutId !== null) {
      GLib.source_remove(timeoutId);
      timeoutId = null;
    }
  };

  // Watch isExpanded changes to clear notification when manually collapsed
  isExpanded.subscribe((expanded) => {
    if (!expanded) {
      activeNotification.set(null);
    }
  });

  return (
    <window
      name={`dynamic-island-${monitor}`}
      className="dynamic-island-window"
      visible={true}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={Astal.WindowAnchor.TOP}
      layer={Astal.Layer.TOP}
      margin={-18}
      onDestroy={onDestroy}
    >
      <box className="dynamic-island" hpack={Gtk.Align.CENTER}>
        <eventbox
          // onHover={() => isExpanded.set(true)}
          // onHoverLost={() => isExpanded.set(false)}
          onClick={() =>
            isExpanded.get() ? isExpanded.set(false) : isExpanded.set(true)
          }
        >
          <box
            className={bind(isExpanded).as((v) =>
              v ? "dynamic-island-inner expanded" : "dynamic-island-inner"
            )}
          >
            <box className="dynamic-island-content">
              {bind(activeNotification).as((notification) =>
                notification ? (
                  <box className="notification-container">
                    {/* App Icon */}
                    <box className="notification-icon">
                      {notification.app_icon ? (
                        <icon icon={notification.app_icon} size={24} />
                      ) : (
                        <box className="fallback-icon" />
                      )}
                    </box>

                    {/* Notification Content */}
                    <box className="notification-content" hexpand={true}>
                      <box orientation="vertical">
                        <label
                          className="notification-title"
                          xalign={0}
                          wrap={true}
                          label={notification.summary || "Notification"}
                        />
                        <label
                          className="notification-body"
                          xalign={0}
                          wrap={true}
                          label={notification.body || ""}
                        />
                      </box>
                    </box>
                  </box>
                ) : (
                  ""
                )
              )}
            </box>
            <LabelMe text="fitrah" />
          </box>
        </eventbox>
      </box>
    </window>
  );
};

export default DynamicIsland;
