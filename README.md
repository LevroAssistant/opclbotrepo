# OpenClaw local audio transcription wrapper

This repo contains a small wrapper script for local Telegram/OpenClaw audio transcription using:

- `ffmpeg` for input conversion
- `whisper.cpp` for local speech-to-text

## Files

- `transcribe-whisper.sh` — converts inbound audio to 16 kHz mono WAV and runs `whisper-cli`

## Expected local paths

By default the script expects:

- `ffmpeg` at `/usr/bin/ffmpeg`
- `whisper-cli` at `/home/openclaw/.openclaw/workspace/tools/whisper.cpp/build/bin/whisper-cli`
- model at `/home/openclaw/.openclaw/workspace/tools/whisper.cpp/models/ggml-base.bin`

These can be overridden with env vars:

- `FFMPEG_BIN`
- `WHISPER_BIN`
- `WHISPER_CPP_MODEL`
- `WHISPER_LANG`
- `WHISPER_THREADS`

## Example OpenClaw config snippet

```json
{
  "tools": {
    "media": {
      "audio": {
        "enabled": true,
        "models": [
          {
            "type": "cli",
            "command": "/absolute/path/to/transcribe-whisper.sh",
            "args": ["{{MediaPath}}"],
            "timeoutSeconds": 60,
            "language": "auto"
          }
        ]
      }
    }
  }
}
```

## Notes

- Telegram voice notes may arrive as OGG/Opus, so transcoding via `ffmpeg` is the reliable path.
- The script prints transcript text to stdout for OpenClaw to consume.
- For predominantly Russian voice messages, setting the wrapper default language to `ru` is usually more reliable than `auto`, especially for short Telegram voice notes.
