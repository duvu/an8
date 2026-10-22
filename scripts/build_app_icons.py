#!/usr/bin/env python3
"""Generate Android/iOS launcher icons from assets/branding (Media Kit v0.4).

Sources: app_icon_master_1024.png (opaque, full bleed) and
android_adaptive_foreground_432.png (transparent, 108dp canvas at xxxhdpi).
The adaptive background is a flat color (#073F3B), so it is a color resource.
Re-run after any change to the branding sources.
"""
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
BRAND = ROOT / 'assets' / 'branding'
RES = ROOT / 'android' / 'app' / 'src' / 'main' / 'res'
IOS = ROOT / 'ios' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset'
BACKGROUND = '#073F3B'

# density -> (legacy launcher px, adaptive 108dp px)
DENSITIES = {'mdpi': (48, 108), 'hdpi': (72, 162), 'xhdpi': (96, 216),
             'xxhdpi': (144, 324), 'xxxhdpi': (192, 432)}


def resized(src: Image.Image, px: int) -> Image.Image:
    return src.resize((px, px), Image.Resampling.LANCZOS)


def main() -> None:
    master = Image.open(BRAND / 'app_icon_master_1024.png').convert('RGB')
    foreground = Image.open(BRAND / 'android_adaptive_foreground_432.png').convert('RGBA')

    for density, (legacy, adaptive) in DENSITIES.items():
        out = RES / f'mipmap-{density}'
        out.mkdir(parents=True, exist_ok=True)
        resized(master, legacy).save(out / 'ic_launcher.png', optimize=True)
        resized(foreground, adaptive).save(out / 'ic_launcher_foreground.png', optimize=True)

    anydpi = RES / 'mipmap-anydpi-v26'
    anydpi.mkdir(parents=True, exist_ok=True)
    (anydpi / 'ic_launcher.xml').write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@color/ic_launcher_background"/>\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
        '</adaptive-icon>\n', encoding='utf-8')
    values = RES / 'values'
    values.mkdir(parents=True, exist_ok=True)
    (values / 'ic_launcher_background.xml').write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        f'    <color name="ic_launcher_background">{BACKGROUND}</color>\n</resources>\n',
        encoding='utf-8')

    # iOS: every entry of the existing Contents.json, opaque RGB (App Store rule).
    contents = json.loads((IOS / 'Contents.json').read_text(encoding='utf-8'))
    for image in contents['images']:
        points = float(image['size'].split('x')[0])
        scale = int(image['scale'].rstrip('x'))
        resized(master, round(points * scale)).save(IOS / image['filename'], optimize=True)
    print('Icons written for', len(DENSITIES), 'Android densities and',
          len(contents['images']), 'iOS slots')


if __name__ == '__main__':
    main()
