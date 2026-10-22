# AN NHIÊN — UNIFIED MEDIA RESTORATION v0.7

## What changed

- **v0.6 drawings and tiny diagram previews are fully excluded.** No v0.6 assets are in this release.
- **v1.1 basic series are copied unchanged** (`assets/series/E01–E07/`). Visual style is preserved.
- **v0.3 original studio pose posters and frames** are retained with their native file names under the Flutter content package.
- **67 uniform exercise listing cards** use the original v1.1/v0.3 photo look, cream/teal palette, proper Vietnamese fonts, and clear draft labels. They are *catalog thumbnails only*.
- **Five routine covers** created in the same visual system.
- **67 production scripts / existing WebVTT drafts / prompts** from v0.5 are included. Do not mistake scripts/VTT for finished voice/video.
- **Four application sound cues**, with countdown volume lowered by 6 dB (M4A), are included.
- `media_manifest.csv`, `assets/catalog/visual_registry.v1.json`, and Flutter package `listing_media.v1.json` provide stable paths, statuses and checksums.

## Critical safety / correctness

**THIS IS NOT A FINAL TRAINING MEDIA RELEASE.** Expert-reviewed pose/video/voice has not been produced. The visual inventory is now consistent but not the medical/movement quality.

- Original E04 frame 03 shows arms too high. **NOT FIXED**: flagged and gated.
- Original E06 images show knees too high and no chair support. **NOT FIXED**: flagged and gated.
- Only 14/60 Eastern forms have their original v0.3 step storyboard; the other 46 retain title placeholders. Listing cards show an explicit 'not exercise-specific' marker and must not be shown in Coach/Player mode as pose cues.
- Tẩy Tủy Kinh remains research-only. No fake pose sequence created.
- All Eastern catalogs remain draft, with no reviewer/date invented.

## Install

1. Extract at the **repository root** (merge, do not overwrite existing app assets blindly).
2. Native package: `packages/an_nhien_eastern_content` — the original Dart ContentRepository and pubspec from v0.1 are preserved; referenced media updated to v0.3 photos.
3. Flutter pubspec: `an_nhien_eastern_content: {path: ../../packages/an_nhien_eastern_content}`.
4. For basic images register `assets/series/`, `assets/covers/`, `assets/listing/`, `assets/audio/cues/`, and `assets/catalog/` in app `pubspec.yaml`.
5. Resolve every pose display through an explicit review gate. **Do not use catalog listing cards as instructional frames.**
6. Run `python scripts/validate_content.py` (requires `jsonschema`) and `python scripts/verify_unified_media.py`.
7. Run Flutter tests and inspect iOS/Android physically. This environment cannot run Flutter; no device-pass claims.

## Remaining work to reach release

- Technical expert selection and signoff for Eastern practice systems (T14).
- Proper review-corrected E04/E06 images.
- 46 missing Eastern pose series, 12 validated chair variants.
- 67 human-taught videos with clear movement and pacing, 67 finalized Vietnamese voice-over+VTT pairs, six qualified pronunciation recordings for Lục Tự Quyết.
- Licenses, reviewer names and dates, subtitle/video sync and T06/T16 integration.

> A complete **visual catalog package** is not the same as complete **approved instructional media**. The difference is enforced in code and manifest.
