import { Variable, GLib, bind } from "astal";
import { Astal, Gtk, Gdk, App } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";

function SysTray() {
  const tray = Tray.get_default();

  return (
    <box className="SysTray">
      {bind(tray, "items").as((items) =>
        items.map((item) => (
          <menubutton
            tooltipMarkup={bind(item, "tooltipMarkup")}
            usePopover={false}
            actionGroup={bind(item, "actionGroup").as((ag) => ["dbusmenu", ag])}
            menuModel={bind(item, "menuModel")}
          >
            <icon gicon={bind(item, "gicon")} />
          </menubutton>
        ))
      )}
    </box>
  );
}

function Wifi() {
  const network = Network.get_default();
  const wifi = bind(network, "wifi");

  return (
    <box visible={wifi.as(Boolean)}>
      {wifi.as(
        (wifi) =>
          wifi && (
            <box>
              <icon
                tooltipText={bind(wifi, "strength").as(String)}
                className="Wifi"
                icon={bind(wifi, "iconName")}
              />
              <label>{bind(wifi, "ssid").as(String)}</label>
            </box>
          )
      )}
    </box>
  );
}

function BatteryLevel() {
  const bat = Battery.get_default();

  return (
    <box className="Battery" visible={bind(bat, "isPresent")}>
      <icon icon={bind(bat, "batteryIconName")} />
      <label
        label={bind(bat, "percentage").as((p) => ` ${Math.floor(p * 100)}%`)}
      />
    </box>
  );
}

function Media() {
  const mpris = Mpris.get_default();

  return (
    <box className="Media">
      {bind(mpris, "players").as((ps) =>
        ps[0] ? (
          <box>
            <box
              className="Cover"
              valign={Gtk.Align.CENTER}
              css={bind(ps[0], "coverArt").as(
                (cover) => `background-image: url('${cover}');`
              )}
            />
            <label
              label={bind(ps[0], "metadata").as(() => {
                const maxLength = 15;
                const title =
                  ps[0].title.length > maxLength
                    ? ps[0].title.substring(0, maxLength) + "..."
                    : ps[0].title;
                const artist =
                  ps[0].artist.length > maxLength
                    ? ps[0].artist.substring(0, maxLength) + "..."
                    : ps[0].artist;
                return `${title} - ${artist}`;
              })}
            />
            {/* <label
              label={bind(ps[0], "metadata").as(
                () => `${ps[0].title} - ${ps[0].artist}`
              )}
            /> */}
          </box>
        ) : (
          ""
        )
      )}
    </box>
  );
}

function Workspaces() {
  const hypr = Hyprland.get_default();

  return (
    <box className="Workspaces">
      {bind(hypr, "workspaces").as((wss) =>
        wss
          .filter((ws) => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
          .sort((a, b) => a.id - b.id)
          .map((ws) => (
            <button
              className={bind(hypr, "focusedWorkspace").as((fw) =>
                ws === fw ? "focused" : ""
              )}
              onClicked={() => ws.focus()}
            >
              {ws.id}
            </button>
          ))
      )}
    </box>
  );
}

function FocusedClient() {
  const hypr = Hyprland.get_default();
  const focused = bind(hypr, "focusedClient");

  return (
    <box className="Focused" visible={focused.as(Boolean)}>
      {focused.as(
        (client) =>
          client && (
            <label
              label={bind(client, "title").as((title) => {
                const maxLength = 30;
                return title.length <= maxLength
                  ? title
                  : title.substring(0, 30) + "...";
              })}
            />
          )
      )}
    </box>
  );
}

function Time({ format = "%H:%M" }) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!
  );

  return (
    <button className="Clock" onClicked={"ags toggle calendar"}>
      <label onDestroy={() => time.drop()} label={time()} />
    </button>
  );
}

export default function Bar(monitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      name={"Bar"}
      className="Bar"
      application={App}
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Workspaces />
          <FocusedClient />
        </box>
        <box>
          <Media />
        </box>
        <box hexpand halign={Gtk.Align.END}>
          <SysTray />
          <Wifi />
          <BatteryLevel />
          <Time />
        </box>
      </centerbox>
    </window>
  );
}
