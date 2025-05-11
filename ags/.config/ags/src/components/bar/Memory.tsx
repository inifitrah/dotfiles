import { bind, Variable } from "astal";

const mem = Variable({ total: 0, used: 0 }).poll(
  5000,
  ["free", "--mebi"],
  (out, _prev) => {
    const mem = out.split("\n")[1];
    const [_, total, used, free, ..._rest] = mem.split(/\s+/);
    return { used: Number(used), total: Number(total), free: Number(free) };
  }
);

export default function Memory() {
  return (
    <button
      onClick={() => {
        mem.stopPoll();
        mem.startPoll();
      }}
      className="Memory"
    >
      {bind(mem).as(({ used }) => {
        const usedGB = (used / 1024).toFixed(1);
        return `󰍛 ${usedGB} GB`;
      })}
    </button>
  );
}
