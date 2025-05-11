import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

export function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focused = bind(hypr, "focusedClient");

  return (
    <box className="Focused" visible={focused.as(Boolean)}>
      {focused.as((client) =>
        client
          ? [
              <label
                tooltipMarkup={"Focused Client"}
                label={bind(client, "initialTitle").as((appName) => {
                  return appName;
                })}
              />,
            ]
          : undefined
      )}
    </box>
  );
}
