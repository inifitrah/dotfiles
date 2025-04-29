// @ts-nocheck
import { Variable, GLib, bind } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Notifd from "gi://AstalNotifd";
import type { EventBox } from "astal/gtk3/widget";

const Whoami = () => {
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
};

// Helper functions dari Notification.tsx
const isIcon = (icon: string) => !!Astal.Icon.lookup_icon(icon);
const fileExists = (path: string) => GLib.file_test(path, GLib.FileTest.EXISTS);
const time = (time: number, format = "%H:%M") =>
  GLib.DateTime.new_from_unix_local(time).format(format)!;

const urgency = (n: Notifd.Notification) => {
  const { LOW, NORMAL, CRITICAL } = Notifd.Urgency;
  switch (n.urgency) {
    case LOW:
      return "low";
    case CRITICAL:
      return "critical";
    case NORMAL:
    default:
      return "normal";
  }
};

// Dynamic Island component
const DynamicIsland = (monitor: Gdk.Monitor) => {
  const isHovered = Variable(false);
  const activeNotification = Variable<Notifd.Notification | null>(null);
  const isExpanded = Variable(false);
  let timeoutId: number | null = null;

  const notifd = Notifd.get_default();

  // Subscribe to new notifications
  notifd.connect("notified", (_, id) => {
    const notification = notifd.get_notification(id);
    if (!notification) return;
    activeNotification.set(notification);
    isExpanded.set(true);

    // Cancel previous timeout if any
    if (timeoutId !== null) {
      GLib.source_remove(timeoutId);
      timeoutId = null;
    }

    // Auto collapse after 3 seconds
    timeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 3000, () => {
      isExpanded.set(false);
      // Timeout akan menghilangkan notifikasi setelah collapsed
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

  // Handle notifikasi dismiss
  const onNotificationDismiss = () => {
    if (activeNotification.get()) {
      activeNotification.get().dismiss();
      isExpanded.set(false);
    }
  };

  return (
    <window
      name={`dynamic-island-${monitor}`}
      className="dynamic-island-window"
      visible={true}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={Astal.WindowAnchor.TOP}
      layer={Astal.Layer.TOP}
      margin={7}
      onDestroy={onDestroy}
    >
      <eventbox
        onHover={() => isHovered.set(true)}
        onHoverLost={() => isHovered.set(false)}
        onClick={() => isExpanded.set(!isExpanded.get())}
      >
        <box className="dynamic-island" hpack={Gtk.Align.CENTER}>
          <box
            className={bind(isExpanded).as((v) =>
              v ? "dynamic-island-inner expanded" : "dynamic-island-inner"
            )}
          >
            <box className="dynamic-island-content">
              {bind(activeNotification).as((notification) =>
                notification ? (
                  <box
                    className={`notification-container ${urgency(
                      notification
                    )}`}
                    vertical
                  >
                    <box className="header">
                      {(notification.appIcon || notification.desktopEntry) && (
                        <icon
                          className="app-icon"
                          icon={
                            notification.appIcon || notification.desktopEntry
                          }
                          size={24}
                        />
                      )}
                      <label
                        className="app-name"
                        halign={Gtk.Align.START}
                        truncate
                        label={notification.appName || "Notification"}
                      />
                      <label
                        className="time"
                        hexpand
                        halign={Gtk.Align.END}
                        label={time(notification.time)}
                      />
                    </box>

                    <box className="content">
                      {notification.image && fileExists(notification.image) && (
                        <box
                          valign={Gtk.Align.START}
                          className="image"
                          css={`
                            background-image: url("${notification.image}");
                          `}
                        />
                      )}
                      {notification.image && isIcon(notification.image) && (
                        <box valign={Gtk.Align.START} className="icon-image">
                          <icon icon={notification.image} size={48} />
                        </box>
                      )}

                      <box vertical className={"notification-text"}>
                        <label
                          className="summary"
                          halign={Gtk.Align.START}
                          xalign={0}
                          label={notification.summary || ""}
                          truncate
                        />
                        {notification.body && (
                          <label
                            className="body"
                            wrap
                            useMarkup
                            halign={Gtk.Align.START}
                            xalign={0}
                            label={notification.body}
                          />
                        )}
                      </box>
                    </box>

                    {notification.get_actions().length > 0 && (
                      <box className="actions">
                        {notification.get_actions().map(({ label, id }) => (
                          <button
                            hexpand
                            onClicked={() => {
                              notification.invoke(id);
                              isExpanded.set(false);
                            }}
                          >
                            <label label={label} />
                          </button>
                        ))}
                      </box>
                    )}
                  </box>
                ) : (
                  ""
                )
              )}
            </box>
            {bind(isExpanded).as((expanded) => (expanded ? "" : <Whoami />))}
          </box>
        </box>
      </eventbox>
    </window>
  );
};

export default DynamicIsland;
