#!/usr/bin/env bash
# Positions eDP-1 centered below the Lenovo P24h-2L when connected.
# Resets eDP-1 to auto-placement otherwise.

lenovo_connected() {
    niri msg --json outputs | jq -e '
        to_entries[] | select(.value.make == "Lenovo Group Limited" and .value.model == "P24h-2L")
    ' > /dev/null 2>&1
}

edp1_at() {
    local target_x=$1 target_y=$2
    local pos
    pos=$(niri msg --json outputs | jq -r '.["eDP-1"].logical | "\(.x) \(.y)"')
    [ "$pos" = "$target_x $target_y" ]
}

position_edp1() {
    if lenovo_connected; then
        edp1_at 0 0 || niri msg output eDP-1 position set 0 0
    else
        niri msg output eDP-1 position auto
    fi
}

# Initial positioning
position_edp1

# React to output/config changes via event stream
niri msg --json event-stream | while IFS= read -r event; do
    if printf '%s' "$event" | jq -e '.WorkspacesChanged // .ConfigLoaded' > /dev/null 2>&1; then
        position_edp1
    fi
done
