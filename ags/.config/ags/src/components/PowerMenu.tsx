import { App, Astal, Gdk, Gtk } from "astal/gtk3";

export const WINDOW_NAME = "powermenu";

const icons = {
  sleep: "weather-clear-night-symbolic",
  reboot: "system-reboot-symbolic",
  logout: "system-log-out-symbolic",
  shutdown: "system-shutdown-symbolic",
};

const options = {
  sleep: "systemctl suspend",
  reboot: "systemctl reboot",
  logout: "pkill Hyprland",
  shutdown: "shutdown now",
};

function SysButton({ action, label }: { action: string; label: string }) {
  return (
    <button
      tooltipText={label}
      className={"sys-btn"}
      onClicked={options[action]}
    >
      <box>
        <icon icon={icons[action]} iconSize={Gtk.IconSize.LARGE} />
        {/* <label label={label} /> */}
      </box>
    </button>
  );
}

export default function PowerMenu(monitor: Gdk.Monitor) {
  const { TOP, RIGHT, BOTTOM, LEFT } = Astal.WindowAnchor;
  return (
    <window
      name={"powermenu"}
      className={"power-menu-container"}
      exclusivity={Astal.Exclusivity.IGNORE}
      animation="popin 80%"
      anchor={TOP}
      marginTop={50}
      gdkmonitor={monitor}
      application={App}
      visible={false}
      keymode={Astal.Keymode.EXCLUSIVE}
      onKeyPressEvent={(self, event: Gdk.Event) => {
        if (event.get_keyval()[1] === Gdk.KEY_Escape) {
          self.hide();
        }
      }}
    >
      <box spacing={8} className={"power-menu"}>
        <SysButton action={"sleep"} label={"Sleep"} />
        <SysButton action={"logout"} label={"Log Out"} />
        <SysButton action={"reboot"} label={"Reboot"} />
        <SysButton action={"shutdown"} label={"Shutdown"} />
      </box>
    </window>
  );
}
