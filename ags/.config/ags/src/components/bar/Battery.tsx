import { bind } from "astal";
import Battery from "gi://AstalBattery";

export function BatteryLevel() {
  const bat = Battery.get_default();

  const icon = bind(bat, "percentage")
    .as((b) => Math.round(b * 10) * 10)
    .as((b) => `battery-level-${b}-symbolic`);
  const label = bind(bat, "percentage").as((b) => `${Math.round(b * 100)}%`);
  return (
    <box>
      <icon icon={icon} />
      <label>{label}</label>
    </box>
  );
}
