#!/usr/bin/env python3
"""Re-sequence E04 and E06 from existing master crops (no new photography).

E04 frame 03 raised the arms overhead although the safety note says "không cần
nâng quá đầu"; E06 frames 02-03 lifted the knee to hip height. Both are rebuilt
from crops already in the master sheet:
  E04: stand, arms ~45° sideways, hold ~45°, stand  (crops 1, 4, 4, 1)
  E06: stand, low step right (crop 4 mirrored), low step left (crop 4),
       low step (mirrored)
Baked step badges are erased and redrawn with the new step number, and the
matching photo cells of storyboard.png / thumbnail.png are patched.
Run after scripts/build_series_assets.py, then scripts/generate_catalog.py.
Still open: E06 has no visible chair support (needs a reshoot) — TRACKER T20.
"""
import importlib.util
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('build', ROOT / 'scripts/build_series_assets.py')
build = importlib.util.module_from_spec(spec)
spec.loader.exec_module(build)

CREAM = '#FAF9F3'
CELL_BG = '#E8F0EA'
FONT = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
# (crop index into ITEMS[...]['frames'], mirror)
SEQUENCES = {
    'E04': [(0, False), (3, False), (3, False), (0, False)],
    'E06': [(0, False), (3, True), (3, False), (3, True)],
}


def badge_bbox(img):
    """Bounding box of the dark-teal step badge in the top-left corner of a crop.

    The search box is kept small: the instructor's teal shirt has the same colour.
    """
    w, h = img.size
    px = img.load()
    xs, ys = [], []
    for y in range(int(h * 0.22)):
        for x in range(int(w * 0.35)):
            r, g, b = px[x, y][:3]
            if r < 45 and 45 < g < 120 and 40 < b < 110:
                xs.append(x)
                ys.append(y)
    if len(xs) < 20:
        raise ValueError('step badge not found')
    colours = sorted(px[x, y][:3] for x, y in zip(xs, ys))
    return (min(xs), min(ys), max(xs), max(ys)), colours[len(colours) // 2]


def relabel(crop, number, mirror):
    box, teal = badge_bbox(crop)
    img = ImageOps.mirror(crop) if mirror else crop.copy()
    w = img.width
    x0, y0, x1, y1 = box
    erase = (w - 1 - x1, y0, w - 1 - x0, y1) if mirror else box
    # Fill the old badge with the wall colour sampled just below it.
    sample = img.crop((erase[0], min(erase[3] + 2, img.height - 2),
                       erase[2] + 1, min(erase[3] + 6, img.height - 1)))
    pixels = sorted(sample.get_flattened_data())
    wall = pixels[len(pixels) // 2]
    draw = ImageDraw.Draw(img)
    draw.rectangle((erase[0] - 1, erase[1] - 1, erase[2] + 1, erase[3] + 1), fill=wall)
    # New badge where the original sat (top-left), same colour; a badge cut by
    # the crop edge is redrawn as a full circle just inside the edge.
    diameter = y1 - y0
    x0 = max(x0, x1 - diameter, 2)
    x1 = x0 + diameter
    box = (x0, y0, x1, y1)
    draw.ellipse(box, fill=teal)
    size = max(8, int((y1 - y0) * 0.62))
    font = ImageFont.truetype(FONT, size)
    draw.text(((x0 + x1) / 2, (y0 + y1) / 2), str(number), font=font,
              fill='white', anchor='mm')
    return img


def frame_canvas(photo):
    canvas = Image.new('RGB', (680, 680), CREAM)
    im = ImageOps.contain(photo, (650, 630), Image.Resampling.LANCZOS)
    canvas.paste(im, ((680 - im.width) // 2, (680 - im.height) // 2))
    return canvas


def patch_poster(poster, photos):
    """Replace the photo inside each 2×2 cell, keeping badges and captions."""
    cellw, cellh, top = 482, 430, 273
    area = (cellw - 24, cellh - 112)
    for i, photo in enumerate(photos):
        x = 48 + (i % 2) * 496
        y = top + (i // 2) * (cellh + 11)
        badge = poster.crop((x + 12, y + 12, x + 62, y + 62))
        ImageDraw.Draw(poster).rectangle(
            (x + 12, y + 12, x + cellw - 12, y + 12 + area[1]), fill=CELL_BG)
        scaled = ImageOps.contain(photo, area, Image.Resampling.LANCZOS)
        poster.paste(scaled, (x + (cellw - scaled.width) // 2,
                              y + 12 + (area[1] - scaled.height) // 2))
        poster.paste(badge, (x + 12, y + 12))
    return poster


def main():
    items = {item['id']: item for item in build.ITEMS}
    for eid, sequence in SEQUENCES.items():
        rects = items[eid]['frames']
        dest = ROOT / 'assets' / 'series' / eid
        photos = []
        for step, (index, mirror) in enumerate(sequence, start=1):
            crop = build.master.crop(rects[index]).convert('RGB')
            photo = relabel(crop, step, mirror)
            photos.append(photo)
            frame_canvas(photo).save(dest / 'frames' / f'{step:02d}.png', optimize=True)
        poster = patch_poster(Image.open(dest / 'storyboard.png').convert('RGB'), photos)
        poster.save(dest / 'storyboard.png', optimize=True)
        poster.resize((540, 720), Image.Resampling.LANCZOS).save(dest / 'thumbnail.png', optimize=True)
        print(eid, 'rebuilt from crops', [i + 1 for i, _ in sequence])


if __name__ == '__main__':
    main()
