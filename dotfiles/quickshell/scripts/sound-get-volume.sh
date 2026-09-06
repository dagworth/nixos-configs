#!/bin/bash
wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ printf "%d %d\n", $2 * 100, ($3 == "[MUTED]") }'
