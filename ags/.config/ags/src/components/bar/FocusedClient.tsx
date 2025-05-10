import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

export function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focused = bind(hypr, "focusedClient");

  return (
    <box className="Focused" visible={focused.as(Boolean)}>
      {focused.as(
        (client) =>
          client && (
            <label
              label={bind(client, "title").as((title) => {
                const maxLength = 30;
                return title.length <= maxLength
                  ? title
                  : title.substring(0, 30) + "...";
              })}
            />
          )
      )}
    </box>
  );
}
