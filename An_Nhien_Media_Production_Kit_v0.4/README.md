# An Nhiên — Media Production Kit v0.4

**Production infrastructure plus P0 UI assets. NOT a complete, publicly publishable exercise library.**

This ZIP can be copied to an An Nhiên Flutter workspace as a production reference/add-on. It does not overwrite existing content catalog, app code, or v0.3 draft images.

## Contents

- `assets/icons/`: iOS 1024 opaque app icon and Android 432 adaptive foreground/background, plus master PNG.
- `source/app_icon_master.svg`: editable vector source for the icon.
- `assets/audio/cues/`: 4 original, gentle synthetic UI sounds in both OGG and M4A, all 48kHz mono.
- `assets/media/E01`–`E07/`: **script-stage** WebVTT and `voice_script.json` cue drafts only, not final voice recordings or true video-synced captions.
- `media_manifest.csv`: 402 **physical** intended files, plus status, rights, reviewer and SHA-256 columns.
- `catalog/`: list of 60 eastern exercises derived from v0.3 and prospective plan paths.
- `docs/06_MEDIA_SPEC.md`: authoritative media production contract; `docs/PRODUCTION_BACKLOG.md`: pending tasks.
- `scripts/validate_media.py`: technical validation plus explicit release gate.
- `reference/ai_style_reference_NOT_FOR_TRAINING.png`: art-direction only; cannot be used as a technique guide.

## How to use

1. Copy `assets/icons`, `assets/audio/cues`, `scripts` and `docs` to repository root, merging without overwriting unrelated files.
2. Add icon and cue assets to Flutter configuration, integrate T06 Player cue timing (10 seconds before next move, countdown, new move, complete).
3. Import `media_manifest.csv` as the P0/P1 production worklist; produce media under exact target paths.
4. Ensure the named instructor/reviewer approves each martial movement and associated voice/caption; update catalog/media plans and metadata.
5. Run `python scripts/validate_media.py --mode inventory` to audit inventory and `--mode release` to gate publishing.

**Limitations:** All 67 video files, the 60×3 approved Eastern pose images, chair alternatives, the final spoken instructions, and Lục Tự Quyết pronunciation samples still require real production and expert verification. Do NOT publish those as completed.
