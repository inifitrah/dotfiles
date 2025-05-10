import { bind } from "astal";
import Network from "gi://AstalNetwork";

export function Wifi() {
  const network = Network.get_default();
  const wifi = bind(network, "wifi");

  return (
    <box visible={wifi.as(Boolean)}>
      {wifi.as((wifi) =>
        wifi ? (
          <box>
            <icon
              tooltipText={bind(wifi, "strength").as(
                (str) => `${str}% ${wifi.ssid}`
              )}
              className="Wifi"
              icon={bind(wifi, "iconName")}
            />
          </box>
        ) : (
          <box>
            <icon
              className="Wifi"
              tooltipText={"No Wifi"}
              icon={bind(wifi, "iconName")}
            />
          </box>
        )
      )}
    </box>
  );
}
