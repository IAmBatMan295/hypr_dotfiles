#!/bin/bash

# State-based screen recorder using wf-recorder
# Toggle script: First run opens menu to start, second run stops recording

RECORDINGS_DIR="$HOME/Pictures/Recordings"
PIDFILE="/tmp/wf-recorder.pid"

# Create recordings directory if it doesn't exist
mkdir -p "$RECORDINGS_DIR"

# Check if recording is active (running state)
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    # RUNNING STATE -> CLOSED STATE: Stop recording
    kill -SIGINT "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE"
    notify-send "Recording Stopped" "Saved to $RECORDINGS_DIR" -t 3000
    exit 0
fi

# CLOSED STATE -> RUNNING STATE: Show menu and start recording

# Recording profiles (optimized for Vega 8 + HDD)
# Video: h264_vaapi hardware encoding, 1080p
# Audio: 256kbps AAC, Lossless FLAC, or No Audio
profiles=(
    "30fps • 256kbps"
    "30fps • Lossless"
    "30fps • No Audio"
    "60fps • 256kbps"
    "60fps • Lossless"
    "60fps • No Audio"
)

# Show rofi menu (auto-size, 6 lines)
selected=$(printf '%s\n' "${profiles[@]}" | rofi -dmenu -i -p "Screen Record" -theme-str 'listview {lines: 6;} entry {width: 200px;}')

# Exit if nothing selected (Escape pressed)
[ -z "$selected" ] && exit 0

# Parse selection
case "$selected" in
    "30fps • 256kbps")
        FPS=30
        AUDIO_CODEC="aac"
        AUDIO_BITRATE="256k"
        NO_AUDIO=false
        EXT="mp4"
        LABEL="30fps-1080p-256kbps"
        ;;
    "30fps • Lossless")
        FPS=30
        AUDIO_CODEC="flac"
        AUDIO_BITRATE=""
        NO_AUDIO=false
        EXT="mkv"
        LABEL="30fps-1080p-lossless"
        ;;
    "30fps • No Audio")
        FPS=30
        NO_AUDIO=true
        EXT="mp4"
        LABEL="30fps-1080p-no-audio"
        ;;
    "60fps • 256kbps")
        FPS=60
        AUDIO_CODEC="aac"
        AUDIO_BITRATE="256k"
        NO_AUDIO=false
        EXT="mp4"
        LABEL="60fps-1080p-256kbps"
        ;;
    "60fps • Lossless")
        FPS=60
        AUDIO_CODEC="flac"
        AUDIO_BITRATE=""
        NO_AUDIO=false
        EXT="mkv"
        LABEL="60fps-1080p-lossless"
        ;;
    "60fps • No Audio")
        FPS=60
        NO_AUDIO=true
        EXT="mp4"
        LABEL="60fps-1080p-no-audio"
        ;;
    *)
        exit 1
        ;;
esac

# Generate filename with timestamp
FILENAME="recording-$(date +%Y-%m-%d_%H-%M-%S).$EXT"
OUTPUT="$RECORDINGS_DIR/$FILENAME"

# Optimized wf-recorder settings for Vega 8 iGPU + HDD:
# --codec=h264_vaapi : Hardware encoding using AMD VAAPI (minimal CPU usage)
# -r $FPS            : Frame rate
# -a                 : Enable audio recording
# -p pix_fmt=nv12    : Fastest pixel format for VAAPI
# -p b=8M / b=15M    : Bitrate cap (8Mbps for 30fps, 15Mbps for 60fps) - reduces encoder stress, good for HDD
# -p g=60 / g=120    : GOP size (keyframe every 2 seconds) - better seeking, reasonable file size

if [ "$FPS" -eq 30 ]; then
    BITRATE="8M"
    GOP="60"
else
    BITRATE="15M"
    GOP="120"
fi

# Build audio parameters and command
if [ "$NO_AUDIO" = true ]; then
    # No audio recording
    AUDIO_ARGS=""
else
    # Get the default audio sink's monitor source
    # This captures system audio without affecting playback quality
    DEFAULT_SINK=$(pactl get-default-sink)
    AUDIO_SOURCE="${DEFAULT_SINK}.monitor"
    
    if [ -n "$AUDIO_BITRATE" ]; then
        AUDIO_ARGS="-a=$AUDIO_SOURCE -R 48000 -C $AUDIO_CODEC -P b=$AUDIO_BITRATE"
    else
        # Lossless (flac) - no bitrate needed
        AUDIO_ARGS="-a=$AUDIO_SOURCE -R 48000 -C $AUDIO_CODEC"
    fi
fi

# Start recording in background
# Using nohup to keep it running after script exits
nohup wf-recorder \
    --codec=h264_vaapi \
    -r "$FPS" \
    $AUDIO_ARGS \
    -p pix_fmt=nv12 \
    -p b="$BITRATE" \
    -p g="$GOP" \
    -f "$OUTPUT" > /tmp/wf-recorder.log 2>&1 &

# Save PID for state management
echo $! > "$PIDFILE"

# Notify user
notify-send "Recording Started" "$LABEL" -t 2000

exit 0
