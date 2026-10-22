#!/usr/bin/env python3
"""Build the bundled background music (D17) from the delivered sources.

Spec (`production_jobs/music/MUSIC_SPEC_SOURCE.md`): instrumental loop,
48 kHz stereo, -23 LUFS so it sits under the cues (~-18 LUFS). The sources
arrive at other levels (v1.0 tracks ~-37 LUFS, Suno ~-15 LUFS), so each is
loudness-normalised; short fades hide the seam when the player loops.
Only tracks that a playable routine uses are bundled (YAGNI).
Requires ffmpeg on PATH. Re-run after replacing a source.
"""
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
V10 = ROOT / 'An_Flutter_Media_Culture_Brand_v1.0' / 'assets' / 'audio' / 'music'
OUT = ROOT / 'assets' / 'audio' / 'music'

# output name -> source. Morning is the owner's Suno track (M1 prompt, file 09).
TRACKS = {
    'music_morning.m4a': ROOT / 'Sáng Bình Yên.mp3',
    'music_evening.m4a': V10 / 'music_evening.m4a',
    'music_qigong.m4a': V10 / 'music_qigong.m4a',
}
FADE_IN, FADE_OUT = 2.0, 3.0


def duration(path: Path) -> float:
    out = subprocess.run(
        ['ffprobe', '-v', 'error', '-show_entries', 'format=duration',
         '-of', 'csv=p=0', str(path)],
        check=True, capture_output=True, text=True)
    return float(out.stdout.strip())


def build(name: str, source: Path) -> None:
    end = duration(source)
    filters = ','.join([
        'loudnorm=I=-23:TP=-2:LRA=11',
        f'afade=t=in:d={FADE_IN}',
        f'afade=t=out:st={end - FADE_OUT:.2f}:d={FADE_OUT}',
    ])
    subprocess.run(
        ['ffmpeg', '-y', '-v', 'error', '-i', str(source), '-vn',
         '-map_metadata', '-1', '-af', filters, '-ar', '48000', '-ac', '2',
         '-c:a', 'aac', '-b:a', '96k', str(OUT / name)],
        check=True)
    print(f'{name}: {end:.0f}s from {source.name}')


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for name, source in TRACKS.items():
        build(name, source)


if __name__ == '__main__':
    main()
