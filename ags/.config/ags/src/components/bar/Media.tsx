import { App } from "astal/gtk3";
import Mpris from "gi://AstalMpris";
import { bind } from "astal";

export const Media = () => {
  const firefox = Mpris.Player.new("firefox.instance_1_33");

  if (firefox.available) print(firefox.artist, firefox.title.substring(0, 20));

  return (
    <>
      {bind(firefox, "available").as((available) =>
        available ? (
          <box className="Media" spacing={6}>
            <button
              className="media-button"
              onClick={() => {
                firefox.play_pause();
              }}
            >
              <icon
                icon={bind(firefox, "playbackStatus").as((status) =>
                  status === Mpris.PlaybackStatus.PLAYING
                    ? "media-playback-pause-symbolic"
                    : "media-playback-start-symbolic"
                )}
              />
            </button>
            <icon icon={bind(firefox, "coverArt")} />
            <label
              className={"media-title"}
              label={bind(firefox, "title").as((title) =>
                title.substring(0, 15)
              )}
            ></label>
            <label
              className={"media-artist"}
              label={bind(firefox, "artist").as((title) =>
                title.substring(0, 15)
              )}
            ></label>
          </box>
        ) : (
          <box></box>
        )
      )}
    </>
  );
};
