#!/usr/bin/env bash
# kill focused client's process via pid (not just killclient)
# single-client mode: focusing-client is primary, all-clients is fallback
# to avoid multi-monitor over-kill (is_focused can be true per monitor)
set -euo pipefail

# --- tunable ---
TERM_WAIT_STEPS=4
TERM_WAIT_INTERVAL=0.5
KILL_REAP_WAIT=0.2
CLEANUP_CHECK_WAIT=0.3
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/mango-kill.lock"

# flock to prevent concurrent presses stacking
exec 9>"$LOCK_FILE" 2>/dev/null || true
if command -v flock >/dev/null 2>&1; then
    flock -n 9 2>/dev/null || { echo "[kill.sh] already running, skip" >&2; exit 0; }
fi

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low "mango kill" "$1" 2>/dev/null || true
    fi
    echo "[kill.sh] $1" >&2
}

is_dead() {
    local pid="$1"
    if ! kill -0 "$pid" 2>/dev/null; then
        return 0
    fi
    local state
    state=$(awk '/^State:/{print $2}' "/proc/$pid/status" 2>/dev/null || echo "")
    [ "$state" = "Z" ]
}

get_pids() {
    local json fc pid
    # primary: focusing-client (single client you are actually focusing)
    fc=$(mmsg get focusing-client 2>/dev/null || true)
    pid=$(printf '%s' "$fc" | jq -r '.pid // empty' 2>/dev/null || true)
    if [ -n "$pid" ] && [ "$pid" != "null" ]; then
        printf '%s\n' "$pid"
        return 0
    fi
    # fallback: all-clients where is_focused==true (may be multiple in multi-monitor)
    json=$(mmsg get all-clients 2>/dev/null) || return 1
    printf '%s' "$json" | jq -r '.clients[] | select(.is_focused==true) | .pid // empty' 2>/dev/null || true
}

main() {
    local mode="${1:-term}"
    local pids
    pids=$(get_pids) || {
        notify "failed to read mmsg"
        exit 1
    }

    if [ -z "$pids" ] || [ "$pids" = "null" ]; then
        notify "no focused client"
        exit 1
    fi

    local json
    json=$(mmsg get all-clients 2>/dev/null || echo '{"clients":[]}')

    local killed=0
    for pid in $pids; do
        if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
            continue
        fi
        if [ "$pid" -le 1 ]; then
            continue
        fi
        if is_dead "$pid"; then
            notify "pid $pid already dead"
            continue
        fi

        local info
        info=$(printf '%s' "$json" | jq -r --argjson pid "$pid" '.clients[] | select(.pid==$pid) | "\(.appid // "?") - \(.title // "?")"' 2>/dev/null | head -n1)
        [ -z "$info" ] && info="pid $pid"

        if [ "$mode" = "kill" ]; then
            if kill -KILL "$pid" 2>/dev/null; then
                notify "SIGKILL $info ($pid)"
                killed=$((killed+1))
            else
                notify "failed SIGKILL $info ($pid)"
            fi
        else
            kill -TERM "$pid" 2>/dev/null || true
            local alive=1
            for _ in $(seq 1 "$TERM_WAIT_STEPS"); do
                sleep "$TERM_WAIT_INTERVAL"
                if is_dead "$pid"; then
                    alive=0
                    break
                fi
            done
            if [ "$alive" -eq 1 ]; then
                if kill -KILL "$pid" 2>/dev/null; then
                    sleep "$KILL_REAP_WAIT"
                    if is_dead "$pid"; then
                        notify "SIGTERM→KILL $info ($pid)"
                    else
                        notify "failed kill $info ($pid)"
                    fi
                else
                    notify "failed SIGKILL after TERM $info ($pid)"
                fi
            else
                notify "SIGTERM $info ($pid)"
            fi
            killed=$((killed+1))
        fi

        local cid
        cid=$(printf '%s' "$json" | jq -r --argjson pid "$pid" '.clients[] | select(.pid==$pid) | .id // empty' 2>/dev/null | head -n1)
        if [ -n "$cid" ] && [ "$cid" != "null" ]; then
            sleep "$CLEANUP_CHECK_WAIT"
            if mmsg get all-clients 2>/dev/null | jq -e --argjson id "$cid" '.clients[] | select(.id==$id)' >/dev/null 2>&1; then
                mmsg dispatch killclient client,"$cid" 2>/dev/null || true
            fi
        fi
    done

    [ "$killed" -gt 0 ] || exit 1
}

main "$@"
