import { bind, GLib } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import type { WindowProps, EventBoxProps, BoxProps } from "astal/gtk3";
import Notifd from "gi://AstalNotifd";

// Import views
import NotificationView from "./NotificationView";
import StatusIndicator from "./StatusIndicator";
import NotificationService from "../../services/DynamicIsland/NotificationService";
import { DynamicIslandStore, Provider } from "./types";

const DynamicIsland = (monitor: Gdk.Monitor) => {
  // Initialize store
  const store = new DynamicIslandStore();

  // Content providers
  const providers: Provider[] = [
    {
      id: "notification",
      priority: 100,
      condition: () => NotificationService.hasNotifications.get(),
      render: () => <NotificationView />,
    },
  ];

  // Update active provider based on conditions and priorities
  const updateActiveProvider = () => {
    const eligible = providers
      .filter((p) => p.condition())
      .sort((a, b) => b.priority - a.priority);

    store.setActiveProvider(eligible[0]?.id || null);
  };

  // Subscribe to new notifications
  NotificationService.latestNotification.subscribe((notification) => {
    if (notification) {
      updateActiveProvider();
      store.setExpanded(true);
      store.setupAutoCollapse();
    }
  });

  // Clean up on destroy
  const onDestroy = () => {
    store.destroy();
  };

  return (
    <window
      name={`dynamic-island-${monitor}`}
      className="dynamic-island-window"
      visible={true}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={Astal.WindowAnchor.TOP}
      layer={Astal.Layer.OVERLAY}
      margin={bind(store.getStateBinding()).as((state) =>
        state.isExpanded ? -15 : -40
      )}
      onDestroy={onDestroy}
    >
      <eventbox
        onHover={() => store.setHovered(true)}
        onHoverLost={() => store.setHovered(false)}
        onClick={() => {
          const state = store.get();
          if (state.isExpanded) {
            store.setExpanded(false);
          } else {
            store.setDashboardOpen(true);
            updateActiveProvider();
          }
        }}
      >
        <box className="dynamic-island" hpack={Gtk.Align.CENTER}>
          <box
            className={bind(store.getStateBinding()).as((state) =>
              state.isExpanded
                ? "dynamic-island-inner expanded"
                : "dynamic-island-inner"
            )}
          >
            {/* Render content based on state */}
            {bind(store.getStateBinding()).as((state) =>
              state.isExpanded ? (
                <box className="dynamic-island-content">
                  {state.activeProviderId ? (
                    providers
                      .find((p) => p.id === state.activeProviderId)
                      ?.render() || <StatusIndicator />
                  ) : (
                    <StatusIndicator />
                  )}
                </box>
              ) : (
                <StatusIndicator />
              )
            )}
          </box>
        </box>
      </eventbox>
    </window>
  );
};

export default DynamicIsland;
