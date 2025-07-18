// @ts-nocheck
import { App, Astal, Gdk } from "astal/gtk3";
import { Connectivity } from "./Connectivity";
import { Sliders } from "./Sliders/Sliders";
import { Variable } from "astal";
import { WiFi } from "./WifiView";
import { Bluetooth } from "./BluetoothView";
import AstalNetwork from "gi://AstalNetwork";
import AstalBluetooth from "gi://AstalBluetooth";
import { Apps } from "./Apps/Apps";
import { SidePanel } from "./SidePanel";

type View = "controlls" | "wifi" | "bluetooth" | "apps";

type ControllProps = { setCurrentView: (view: View) => void };

const Controlls = ({ setCurrentView }: ControllProps) => {
  const network = AstalNetwork.get_default();
  const bluetooth = AstalBluetooth.get_default();

  return (
    <>
      <box className="equal-wrapper">
        <Connectivity
          onWifiPrimary={() => setCurrentView("wifi")}
          onWifiSecondary={() => (network.wifi.enabled = !network.wifi.enabled)}
          onBluetoothPrimary={() => setCurrentView("bluetooth")}
          onBluetoothSecondary={() => bluetooth.toggle()}
        />
      </box>
      <Sliders />
    </>
  );
};

export const ControllCenter = () => {
  const { TOP, LEFT } = Astal.WindowAnchor;

  const currentView = Variable<View>("controlls");
  const reset = () => currentView.set("controlls");
  const resetAndClose = () => {
    reset();
    App.toggle_window("controll-center");
  };

  return (
    <window
      name="controll-center"
      className="ControllCenter"
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={TOP | LEFT}
      application={App}
      margin-top={0}
      margin-left={0}
      setup={(self) => App.add_window(self)}
      visible={false}
      keymode={Astal.Keymode.EXCLUSIVE}
      onKeyPressEvent={(self, event: Gdk.Event) => {
        if (event.get_keyval()[1] === Gdk.KEY_Escape) {
          self.hide();
        }
      }}
    >
      <box>
        <SidePanel currentView={currentView} />
        <box vertical spacing={6} className="ControllCenterWrapper">
          {currentView((view) => {
            switch (view) {
              case "controlls":
                return (
                  <Controlls setCurrentView={(view) => currentView.set(view)} />
                );
              case "wifi":
                return <WiFi reset={reset} />;
              case "bluetooth":
                return <Bluetooth reset={reset} />;
              case "apps":
                return <Apps reset={resetAndClose} />;
            }
          })}
        </box>
      </box>
    </window>
  );
};
