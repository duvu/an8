#!/usr/bin/env python3
from pathlib import Path
import csv, hashlib, json, sys
root=Path(__file__).resolve().parents[1]
with (root/'media_production_tracker.csv').open(encoding='utf-8-sig',newline='') as f:
    rows=list(csv.DictReader(f))
errors=[];missing=[];review_pending=[]
for r in rows:
    rel=Path(r['path'])
    if rel.is_absolute() or '..' in rel.parts:errors.append(f'Invalid path {r["path"]}');continue
    p=root/rel
    if not p.exists():missing.append(r['path']);continue
    if not r['reviewer'] or not r['review_date']:
        review_pending.append(r['path'])
    if r['checksum_sha256']:
        digest=hashlib.sha256(p.read_bytes()).hexdigest()
        if digest!=r['checksum_sha256']: errors.append('Hash mismatch '+r['path'])
ids=[r['path'] for r in rows]
if len(ids)!=len(set(ids)):errors.append('Duplicated output paths')
print(json.dumps({'inventory_count':len(rows),'missing':len(missing),'not_reviewed':len(review_pending),
                  'validation_errors':errors[:20], 'release_ready':not errors and not missing and not review_pending},
                 ensure_ascii=False,indent=2))
sys.exit(0 if not errors and not missing and not review_pending else 1)
