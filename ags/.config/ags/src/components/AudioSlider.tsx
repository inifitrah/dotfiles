import { bind } from "astal";
import { App, Astal, Gdk } from "astal/gtk3";
import Wp from "gi://AstalWp";

export default function AudioSlider(monitor: Gdk.Monitor) {
  const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT;
  const speaker = Wp.get_default()?.audio.defaultSpeaker!;
  return (
    <window
      name="audio-slider"
      visible={false}
      // monitor={0}
      gdkmonitor={monitor}
      application={App}
      anchor={anchor}
    >
      <box css="min-width: 140px; background-color: #333; padding: 0 10px;">
        <slider
          hexpand
          onDragged={({ value }) => (speaker.volume = value)}
          value={bind(speaker, "volume")}
        />
        {/* <label label={bind(speaker, "volume").as(String)} /> */}
      </box>
    </window>
  );
}
