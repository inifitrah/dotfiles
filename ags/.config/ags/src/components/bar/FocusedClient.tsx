import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

export function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focused = bind(hypr, "focusedClient");

  focused.subscribe((client) => {
    console.log("Focused client changed:", client.title);
  });

  return (
    <box className="Focused" visible={focused.as(Boolean)}>
      {focused.as((client) =>
        client
          ? [<label tooltipMarkup={bind(client, "title")} label={"Client"} />]
          : undefined
      )}
    </box>
  );
}
