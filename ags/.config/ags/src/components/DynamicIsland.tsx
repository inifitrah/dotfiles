// filepath: /home/fitrah/.dotfiles/ags/.config/ags/src/components/DynamicIsland.tsx
import { Astal, Gdk, Gtk } from "astal/gtk3";
import { bind, Connectable } from "astal/binding";
import { Variable, GLib } from "astal";
import Mpris from "gi://AstalMpris";
import Notifd from "gi://AstalNotifd";

// Durasi animasi dan timeout
const EXPAND_DURATION = 300;
const NOTIFICATION_TIMEOUT = 5000;
const MUSIC_INFO_TIMEOUT = 5000;

// Status Island
const IslandState = {
  COLLAPSED: 0,
  MUSIC: 1,
  NOTIFICATION: 2,
};

// Debounce function untuk menghindari multiple rapid calls
const debounce = (func: () => void, delay: number) => {
  let timer: any;
  return () => {
    clearTimeout(timer);
    timer = setTimeout(func, delay);
  };
};

function DynamicIslandContent() {
  const islandState = Variable<number>(IslandState.COLLAPSED);
  const mpris = Mpris.get_default();
  const notifd = Notifd.get_default();

  // Variabel untuk menyimpan notifikasi terbaru
  const currentNotification = Variable<any | null>(null);

  // Memantau perubahan pada player musik aktif
  const currentPlayer = Variable<any | null>(null);

  // Kontrol musik - album art, judul, artis, dan status play/pause
  const musicContent = (player: any) => (
    <box className="island-music-container">
      <box
        className="island-album-art"
        css={bind(player, "coverArt").as(
          (cover) => `background-image: url('${cover}');`
        )}
      />
      <box vertical={true}>
        <label
          className="island-music-title"
          label={bind(player, "title").as((title) =>
            title.length > 20 ? title.substring(0, 20) + "..." : title
          )}
        />
        <label
          className="island-music-artist"
          label={bind(player, "artist").as((artist) =>
            artist.length > 20 ? artist.substring(0, 20) + "..." : artist
          )}
        />
      </box>
      <box className="island-music-controls">
        <button
          className="island-music-button"
          onClicked={() => player?.playPause()}
        >
          {bind(player, "playBackStatus").as((status) =>
            status === "Playing" ? "⏸️" : "▶️"
          )}
        </button>
        <button
          className="island-music-button"
          onClicked={() => player?.next()}
        >
          ⏭️
        </button>
      </box>
    </box>
  );

  // Konten notifikasi - ikon aplikasi, judul, dan teks
  const notificationContent = (notification: any) => (
    <box className="island-notification-container">
      <box className="island-notification-icon">
        <icon icon={notification?.appIcon || "dialog-information-symbolic"} />
      </box>
      <box vertical={true}>
        <label
          className="island-notification-title"
          label={notification?.summary || "Notification"}
        />
        <label
          className="island-notification-body"
          label={notification?.body || ""}
        />
      </box>
    </box>
  );

  // Setup revealer untuk menampilkan/menyembunyikan konten berdasarkan status island
  const musicRevealer = (
    <revealer
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={EXPAND_DURATION}
      revealChild={bind(islandState).as((state) => state === IslandState.MUSIC)}
      child={
        <box className="island-expanded-content">
          {bind(currentPlayer).as((player) =>
            player ? musicContent(player) : <box />
          )}
        </box>
      }
    />
  );

  const notificationRevealer = (
    <revealer
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      transitionDuration={EXPAND_DURATION}
      revealChild={bind(islandState).as(
        (state) => state === IslandState.NOTIFICATION
      )}
      child={
        <box className="island-expanded-content">
          {bind(currentNotification).as((notif) =>
            notif ? notificationContent(notif) : <box />
          )}
        </box>
      }
    />
  );

  // Konten collapsed island - hanya menampilkan indikator sederhana
  const collapsedContent = (
    <box className="island-collapsed-content">
      <box className="island-pill" />
    </box>
  );

  const container = (
    <box
      className={bind(islandState).as((state) =>
        state === IslandState.COLLAPSED
          ? "dynamic-island-collapsed"
          : "dynamic-island-expanded"
      )}
      vertical={true}
      setup={(self) => {
        // Pantau perubahan pada musik player
        self.hook(mpris, "player-added", () => {
          const players = mpris.players;
          if (players.length > 0) {
            currentPlayer.set(players[0]);
            islandState.set(IslandState.MUSIC);

            // Kembalikan ke collapsed setelah timeout
            const collapseTimer = debounce(() => {
              islandState.set(IslandState.COLLAPSED);
            }, MUSIC_INFO_TIMEOUT);
            collapseTimer();
          }
        });

        // Pantau perubahan pada playback status (play/pause)
        self.hook(mpris, "player-changed", () => {
          const players = mpris.players;
          if (players.length > 0) {
            currentPlayer.set(players[0]);
            islandState.set(IslandState.MUSIC);

            // Kembalikan ke collapsed setelah timeout
            const collapseTimer = debounce(() => {
              islandState.set(IslandState.COLLAPSED);
            }, MUSIC_INFO_TIMEOUT);
            collapseTimer();
          }
        });

        // Pantau notifikasi baru menggunakan AstalNotifd
        const notifiedHandler = self.connect(notifd, "notified", (_, id) => {
          const notif = notifd.get_notification(id);
          if (notif) {
            // Menyimpan notifikasi ke variable
            currentNotification.set(notif);

            // Update state island
            islandState.set(IslandState.NOTIFICATION);

            // Log untuk debugging
            print(`Notification: ${notif.summary}, ${notif.body}`);

            // Kembalikan ke collapsed atau musik setelah timeout
            const collapseTimer = debounce(() => {
              if (mpris.players.length > 0) {
                islandState.set(IslandState.MUSIC);
              } else {
                islandState.set(IslandState.COLLAPSED);
              }
            }, NOTIFICATION_TIMEOUT);
            collapseTimer();
          }
        });
      }}
    >
      {collapsedContent}
      {musicRevealer}
      {notificationRevealer}
    </box>
  );

  return container;
}

export default (monitor: Gdk.Monitor) => (
  <window
    gdkmonitor={monitor}
    name="dynamic-island"
    namespace="dynamic-island"
    className="dynamic-island-window"
    layer={Astal.Layer.TOP}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.CENTER}
    margin={"-50px 0px 0px 0px"}
    child={DynamicIslandContent()}
  />
);
