#!/usr/bin/env python3
"""Generate the native launch image so it matches the Flutter SplashScreen.

Composition (dp, same numbers as SplashTokens / AppSpacing in lib/app/theme):
  logo   lockup_on_light.png, 96 high, left 55 % of its width (the rest is
         empty), centred horizontally;
  gap    16;
  slogan Roboto Medium 16 / line height 22.4, colour #4E655D, centred.
On cream #FAF9F3 (PrimitiveColors.cream50). Re-run after changing the slogan,
the lockup or those tokens, and keep them in step with splash_screen.dart.
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
LOCKUP = ROOT / 'packages' / 'an_brand' / 'assets' / 'icons' / 'lockup_on_light.png'
RES = ROOT / 'android' / 'app' / 'src' / 'main' / 'res'
IOS = ROOT / 'ios' / 'Runner' / 'Assets.xcassets' / 'LaunchImage.imageset'
FONT = '/usr/share/fonts/truetype/roboto/unhinted/RobotoTTF/Roboto-Medium.ttf'

SLOGAN = 'Cho người hữu duyên'
TEXT_COLOR = (0x4E, 0x65, 0x5D, 255)
LOGO_HEIGHT, CONTENT_FACTOR, GAP = 96, 0.55, 16
FONT_SIZE, LINE_HEIGHT = 16, 22.4
WIDTH = 260
HEIGHT = 135  # ceil(96 + 16 + 22.4)

ANDROID = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
IOS_SCALES = {'LaunchImage.png': 1, 'LaunchImage@2x.png': 2, 'LaunchImage@3x.png': 3}


def render(scale: float) -> Image.Image:
    px = lambda dp: round(dp * scale)  # noqa: E731
    canvas = Image.new('RGBA', (px(WIDTH), px(HEIGHT)), (0, 0, 0, 0))
    lockup = Image.open(LOCKUP).convert('RGBA')
    logo_w = lockup.width * LOGO_HEIGHT / lockup.height
    lockup = lockup.resize((px(logo_w), px(LOGO_HEIGHT)), Image.Resampling.LANCZOS)
    visible = lockup.crop((0, 0, round(lockup.width * CONTENT_FACTOR), lockup.height))
    canvas.alpha_composite(visible, ((canvas.width - visible.width) // 2, 0))
    font = ImageFont.truetype(FONT, px(FONT_SIZE))
    ImageDraw.Draw(canvas).text(
        (canvas.width / 2, px(LOGO_HEIGHT + GAP + LINE_HEIGHT / 2)),
        SLOGAN, font=font, fill=TEXT_COLOR, anchor='mm')
    return canvas


def main() -> None:
    for density, scale in ANDROID.items():
        folder = RES / f'drawable-{density}'
        folder.mkdir(exist_ok=True)
        render(scale).save(folder / 'launch_image.png', optimize=True)
    for name, scale in IOS_SCALES.items():
        render(scale).save(IOS / name, optimize=True)
    print('launch images written')


if __name__ == '__main__':
    main()
