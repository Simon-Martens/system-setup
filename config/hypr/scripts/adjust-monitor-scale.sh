#!/usr/bin/env bash

set -euo pipefail

direction="${1:-}"

if [[ -z "$direction" ]]; then
  echo "usage: $0 <up|down>" >&2
  exit 1
fi

monitor_json="$(hyprctl -j monitors | jq -cer '.[] | select(.focused == true)')"
current_scale="$(jq -r '.scale' <<<"$monitor_json")"

new_scale="$(
  awk -v current="$current_scale" -v direction="$direction" '
    BEGIN {
      split("1.50 1.67 1.88 2.00 2.40 2.67 3.00", scales, " ")
      count = length(scales)
      chosen = scales[1]

      if (direction == "up") {
        chosen = scales[count]
        for (i = 1; i <= count; i++) {
          if (current < scales[i] - 0.0001) {
            chosen = scales[i]
            break
          }
        }
      } else if (direction == "down") {
        chosen = scales[1]
        for (i = count; i >= 1; i--) {
          if (current > scales[i] + 0.0001) {
            chosen = scales[i]
            break
          }
        }
      } else {
        print "invalid direction" > "/dev/stderr"
        exit 1
      }

      printf "%.2f", chosen
    }
  '
)"

monitor_rule="$(
  jq -r --arg scale "$new_scale" '
    .name as $name
    | .width as $width
    | .height as $height
    | (.refreshRate // .refresh // 60) as $refresh
    | .x as $x
    | .y as $y
    | (.transform // 0) as $transform
    | "\($name),\($width)x\($height)@\($refresh),\($x)x\($y),\($scale)"
      + (if $transform != 0 then ",transform,\($transform)" else "" end)
  ' <<<"$monitor_json"
)"

exec hyprctl keyword monitor "$monitor_rule"
