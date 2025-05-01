// @ts-nocheck
import { Variable, GLib, bind } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Notifd from "gi://AstalNotifd";

// Import views
import NotificationView from "./NotificationView";
// import MusicView from "./MusicView";
// import SystemView from "./SystemView";
// import QuickSettings from "./QuickSettings";
import StatusIndicator from "./StatusIndicator";
import NotificationService from "../../services/DynamicIsland/NotificationService";

// Provider type for dynamic content
type Provider = {
  id: string;
  priority: number;
  condition: () => boolean;
  render: () => JSX.Element;
};

const DynamicIsland = (monitor: Gdk.Monitor) => {
  // State
  const isHovered = Variable(false);
  const isExpanded = Variable(false);
  const isDashboardOpen = Variable(false);
  const activeProvider = Variable<string | null>(null);
  let timeoutId: number | null = null;

  // Services
  const notifd = Notifd.get_default();

  // Content providers
  const providers: Provider[] = [
    {
      id: "notification",
      priority: 100,
      condition: () => NotificationService.hasNotifications.get(),
      render: () => <NotificationView />,
    },
    {
      id: "music",
      priority: 80,
      condition: () => false, // TODO: Check MPRIS active player
      render: () => <MusicView />,
    },
    {
      id: "system",
      priority: 60,
      condition: () => false, // TODO: System threshold condition
      render: () => <SystemView />,
    },
    {
      id: "dashboard",
      priority: 40,
      condition: () => isDashboardOpen.get(),
      render: () => <QuickSettings />,
    },
  ];

  // Update active provider based on conditions and priorities
  const updateActiveProvider = () => {
    const eligible = providers
      .filter((p) => p.condition())
      .sort((a, b) => b.priority - a.priority);

    if (eligible[0]) {
      activeProvider.set(eligible[0].id);
    } else {
      activeProvider.set(null);
    }
  };

  // Subscribe to new notifications
  NotificationService.latestNotification.subscribe((notification) => {
    if (notification) {
      updateActiveProvider();
      isExpanded.set(true);

      // Reset timeout
      if (timeoutId !== null) {
        GLib.source_remove(timeoutId);
        timeoutId = null;
      }

      // Auto collapse after 3 seconds
      timeoutId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 3000, () => {
        isExpanded.set(false);
        timeoutId = null;
        return GLib.SOURCE_REMOVE;
      });
    }
  });

  // Clean up on destroy
  const onDestroy = () => {
    isHovered.drop();
    isExpanded.drop();
    isDashboardOpen.drop();
    activeProvider.drop();
    if (timeoutId !== null) {
      GLib.source_remove(timeoutId);
      timeoutId = null;
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
        onClick={() => {
          if (isExpanded.get()) {
            // if expanded, collapse
            isExpanded.set(false);
            isDashboardOpen.set(false);
          } else {
            // if not expanded, expand
            isDashboardOpen.set(true);
            isExpanded.set(true);
            updateActiveProvider();
          }
        }}
      >
        <box className="dynamic-island" hpack={Gtk.Align.CENTER}>
          <box
            className={bind(isExpanded).as((v) =>
              v ? "dynamic-island-inner expanded" : "dynamic-island-inner"
            )}
          >
            {/* Gunakan kondisional bind untuk menampilkan konten yang sesuai */}
            {bind(isExpanded).as((expanded) =>
              expanded ? (
                <box className="dynamic-island-content">
                  {bind(activeProvider).as((provider) => {
                    if (!provider) return <StatusIndicator />;
                    const selected = providers.find((p) => p.id === provider);
                    return selected ? selected.render() : <StatusIndicator />;
                  })}
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
