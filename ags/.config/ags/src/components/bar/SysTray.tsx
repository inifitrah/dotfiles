import { bind } from "astal";
import { Gtk } from "astal/gtk3";
import Tray from "gi://AstalTray";

export function SysTray() {
  const tray = Tray.get_default();

  return (
    <box className="SysTray">
      {bind(tray, "items").as((items) =>
        items.map((item) => (
          <menubutton
            tooltipMarkup={bind(item, "tooltipMarkup")}
            usePopover={false}
            actionGroup={bind(item, "actionGroup").as((ag) => ["dbusmenu", ag])}
            menuModel={bind(item, "menuModel")}
          >
            <icon gicon={bind(item, "gicon")} />
          </menubutton>
        ))
      )}
    </box>
  );
}
