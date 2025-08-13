#!/bin/bash

# Usage:
# sh cut-video.sh sample/target.mp4 source/target.mp4 00:01:00 10

# Parameters initialization
INPUT="$1" # path to source video file
OUTPUT="$2" # path to cutted video file
START="$3" # start time of the cut in format HH:MM:SS
DURATION="$4" # duration in seconds

# Assert arguments
if [ $# -ne 4 ]; then
    echo "Usage: $0 <input> <output> <start_time> <duration_sec>"
    echo "Example: $0 sample/target6.mp4 source/target6-1.mp4 00:01:30 60"
    exit 1
fi

# Cutting video
ffmpeg -ss "$START" -i "$INPUT" -t "$DURATION" \
    -c:v libx264 -crf 18 -preset veryfast -c:a copy "$OUTPUT"
