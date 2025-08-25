#!/usr/bin/env bash

# ------------------------------------------------------------------
#  CONFIGURATION: source & destination directories
# ------------------------------------------------------------------
SRC="/Your/Input/Folder/Path/Here"
DST="/Your/Output/Folder/Path/Here"

mkdir -p -- "$DST"

# ------------------------------------------------------------------
#  ASK USER ABOUT ERROR LOG
# ------------------------------------------------------------------
read -r -p "Save ffmpeg error output to $DST/ffmpeg_error.log? (y/n) " yn
case "$yn" in
    [Yy]* ) LOGFILE="$DST/ffmpeg_error.log"; echo "Logging enabled." ;;
    *     ) LOGFILE="/dev/null"; echo "Logging disabled." ;;
esac

# ------------------------------------------------------------------
#  PRE‑COMPUTE LIST OF FILES AND COUNTERS
# ------------------------------------------------------------------
# Use find – it is safe with spaces, tabs, newlines etc.
mapfile -t files < <(find "$SRC" -maxdepth 1 -type f -iname '*.mp4')
total=${#files[@]}
done_count=0

echo "Starting transcoding of $total clip(s) (H.265 + PCM WAV)…"

for infile in "${files[@]}"; do
    ((done_count++))
    base="${infile##*/}"
    base="${base%.*}"
    outfile="$DST/${base}_h265.mp4"

    echo -e "\n[$done_count/$total] Processing: $infile"
    echo "         Outputting to: $outfile"

    [[ -f "$outfile" ]] && { echo "  → Skipped (already exists)"; continue; }

    # Grab original bit‑rates
    vid_bps=$(ffprobe -v error -select_streams v:0 \
        -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$infile")
    aud_bps=$(ffprobe -v error -select_streams a:0 \
        -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$infile")

    vid_bps=${vid_bps:-0}
    aud_bps=${aud_bps:-0}

    ffmpeg -i "$infile" \
      -c:v libx265 -b:v ${vid_bps} -preset slow \
      -x265-params "log-level=error" \
      -c:a pcm_s16le -b:a ${aud_bps} \
      -hide_banner -nostats -loglevel error \
      -stats \
      "$outfile" 2> >(tee -a "$LOGFILE")

    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully transcoded."
    else
        echo "⚠️  Transcoding failed. Check the log at $LOGFILE"
    fi
done

echo "All done – processed $total clip(s)."
