import { Variable } from "astal";

type RunAsyncCommand = (
  cmd: string,
  args: EventArgs,
  fn?: (output: string) => void,
  postInputUpdater?: Variable<boolean>
) => void;

export const runAsyncCommand: RunAsyncCommand = (
  cmd,
  events,
  fn,
  postInputUpdater?: Variable<boolean>
): void => {
  if (cmd.startsWith("menu:")) {
    const menuName = cmd.split(":")[1].trim().toLowerCase();
    openMenu(events.clicked, events.event, `${menuName}menu`);

    return;
  }

  execAsync(["bash", "-c", cmd])
    .then((output) => {
      handlePostInputUpdater(postInputUpdater);
      if (fn !== undefined) {
        fn(output);
      }
    })
    .catch((err) => console.error(`Error running command "${cmd}": ${err})`));
};
