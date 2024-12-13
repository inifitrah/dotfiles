if ! pgrep -x "waybar" > /dev/null; then
    waybar &
fi

while inotifywait -e modify ~/.config/waybar/config ~/.config/waybar/style.css; do
    if pgrep -x "waybar" > /dev/null; then
        killall waybar
    fi
    waybar &
done

