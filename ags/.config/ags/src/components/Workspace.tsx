import { Gtk } from "astal/gtk3";
import AstalHyprland from "gi://AstalHyprland";
import { bind } from "astal";
import { Variable } from "astal";
import { ButtonProps } from "astal/gtk3/widget";

type WsButtonProps = ButtonProps & {
  ws: AstalHyprland.Workspace;
};

function range(max: number) {
  return Array.from({ length: max + 1 }, (_, i) => i);
}

function WorkspaceButton({ ws, ...props }: WsButtonProps) {
  const hyprland = AstalHyprland.get_default();
  const classNames = Variable.derive(
    [bind(hyprland, "focusedWorkspace"), bind(hyprland, "clients")],
    (fws, _) => {
      const classes = ["workspace-button"];

      const active = fws.id == ws.id;
      active && classes.push("active");

      const occupied = hyprland.get_workspace(ws.id)?.get_clients().length > 0;
      occupied && classes.push("occupied");
      return classes;
    }
  );

  return (
    <button
      className={classNames()}
      onDestroy={() => classNames.drop()}
      valign={Gtk.Align.CENTER}
      halign={Gtk.Align.CENTER}
      onClicked={() => ws.focus()}
      {...props}
    />
  );
}

export default function WorkspacesPanelButton() {
  return (
    <box cssClasses={["workspace-container"]} spacing={5}>
      {range(4).map((i) => (
        <WorkspaceButton ws={AstalHyprland.Workspace.dummy(i + 1, null)} />
      ))}
    </box>
  );
}
