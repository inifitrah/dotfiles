import { Variable } from "astal";
import { App } from "astal/gtk3";

type View = "controlls" | "wifi" | "bluetooth" | "apps" | "mixer";

type TabButton = [string, View];
const tabButtons: TabButton[] = [
  [" ", "controlls"],
  ["󰀻 ", "apps"],
];

export const SidePanel = ({ currentView }: { currentView: Variable<View> }) => (
  <box vertical className="view-select" spacing={6}>
    {tabButtons.map(([icon, view]) => (
      <button
        className={currentView((v) => (v === view ? "focused" : ""))}
        onClick={() => currentView.set(view)}
      >
        {` ${icon}`}
      </button>
    ))}
    <box vexpand />
    <button onClick={() => App.toggle_window("powermenu")}>
      <icon icon={"system-shutdown-symbolic"} />
    </button>
  </box>
);
