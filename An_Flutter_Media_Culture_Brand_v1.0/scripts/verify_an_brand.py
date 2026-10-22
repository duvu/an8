import json
from pathlib import Path
from PIL import Image
base=Path(__file__).resolve().parent.parent
b=json.loads((base/'assets/catalog/brand_manifest.v1.json').read_text())
assert b['displayName']=='An'
for path in b['placements'].values(): assert (base/path).exists(), path
for p in (base/'assets/covers').glob('R*_cover.webp'):
    assert Image.open(p).width>0
print('Brand asset/paths PASS')
