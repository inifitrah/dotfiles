import { GLib, Variable } from "astal";

interface ClockProps {
  format?: string;
}

export function Clock({ format = "%H:%M" }: ClockProps) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!
  );

  return (
    <button
      cursor={"pointer"}
      className="Clock"
      onClicked={"ags toggle calendar"}
    >
      <label onDestroy={() => time.drop()} label={time()} />
    </button>
  );
}
