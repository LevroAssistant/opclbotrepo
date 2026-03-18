#!/usr/bin/env bash
set -euo pipefail

INPUT_PATH="${1:-}"
if [[ -z "$INPUT_PATH" || ! -f "$INPUT_PATH" ]]; then
  echo "missing input audio path" >&2
  exit 2
fi

FFMPEG_BIN="${FFMPEG_BIN:-/usr/bin/ffmpeg}"
WHISPER_BIN="${WHISPER_BIN:-/home/openclaw/.openclaw/workspace/tools/whisper.cpp/build/bin/whisper-cli}"
WHISPER_MODEL="${WHISPER_CPP_MODEL:-/home/openclaw/.openclaw/workspace/tools/whisper.cpp/models/ggml-base.bin}"
WHISPER_LANG="${WHISPER_LANG:-auto}"
WHISPER_THREADS="${WHISPER_THREADS:-4}"

if [[ ! -x "$FFMPEG_BIN" ]]; then
  echo "ffmpeg not found at $FFMPEG_BIN" >&2
  exit 3
fi
if [[ ! -x "$WHISPER_BIN" ]]; then
  echo "whisper-cli not found at $WHISPER_BIN" >&2
  exit 4
fi
if [[ ! -f "$WHISPER_MODEL" ]]; then
  echo "whisper model not found at $WHISPER_MODEL" >&2
  exit 5
fi

TMP_WAV="$(mktemp --suffix=.wav)"
cleanup() {
  rm -f "$TMP_WAV"
}
trap cleanup EXIT

"$FFMPEG_BIN" -nostdin -v error -y -i "$INPUT_PATH" -ar 16000 -ac 1 "$TMP_WAV"

exec "$WHISPER_BIN" "$TMP_WAV" \
  -m "$WHISPER_MODEL" \
  -l "$WHISPER_LANG" \
  -t "$WHISPER_THREADS" \
  -nt \
  -np
