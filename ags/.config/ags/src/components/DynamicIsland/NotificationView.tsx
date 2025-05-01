// @ts-nocheck
import { GLib, Variable, bind } from "astal";
import { Astal, Gtk } from "astal/gtk3";
import Notifd from "gi://AstalNotifd";
import NotificationService from "../../services/DynamicIsland/NotificationService";

// Helper functions
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

export default function NotificationView() {
  return (
    <box>
      {bind(NotificationService.latestNotification).as((notification) => {
        if (!notification) return <box></box>;

        const dismiss = () => notification.dismiss();

        return (
          <box
            className={`notification-container ${urgency(notification)}`}
            vertical
          >
            {/* Header section */}
            <box className="header">
              {(notification.appIcon || notification.desktopEntry) && (
                <icon
                  className="app-icon"
                  icon={notification.appIcon || notification.desktopEntry}
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
              <button
                className={"close-button"}
                margin={"5px 0 0 5px"}
                onClicked={dismiss}
              >
                <icon icon="window-close-symbolic" size={16} />
              </button>
            </box>

            {/* Content section */}
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

              <box vertical className="notification-text">
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

            {/* Actions */}
            {notification.get_actions().length > 0 && (
              <box className="actions">
                {notification.get_actions().map(({ label, id }) => (
                  <button hexpand onClicked={() => notification.invoke(id)}>
                    <label label={label} />
                  </button>
                ))}
              </box>
            )}
          </box>
        );
      })}
    </box>
  );
}
