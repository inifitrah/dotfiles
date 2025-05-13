import { bind } from "astal";
import Notifd from "gi://AstalNotifd";

export const DoNotDisturb = () => {
  const notifs = Notifd.get_default();

  return (
    <button
      hexpand
      className="bordered big-button"
      onClick={() => {
        notifs.dontDisturb = !notifs.dontDisturb;
      }}
    >
      <box>
        <label>
          {bind(notifs, "dontDisturb").as((p) =>
            p ? "  Do not disturb" : "󰂚  Disturb"
          )}
        </label>
      </box>
    </button>
  );
};
