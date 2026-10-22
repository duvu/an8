#!/usr/bin/env python3
"""Validate reusable exercise/routine content and local assets before consumption/publishing.
Exit nonzero on broken references, duplicate IDs, media checksum drift, or unsafe publishing.
"""
import hashlib,json,re,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
try:
 import jsonschema
except ImportError:
 raise SystemExit('Install jsonschema: python -m pip install jsonschema')

catalog=json.loads((ROOT/'catalog/catalog.v1.json').read_text(encoding='utf8'))
schema=json.loads((ROOT/'catalog/catalog.schema.v1.json').read_text(encoding='utf8'))
jsonschema.validate(catalog,schema)
errors=[]
def error(s):errors.append(s)
def index(items,kind):
 out={}
 for e in items:
  k=(e['id'],e['version'])
  if k in out:error(f'duplicate {kind} id/version: {k}')
  out[k]=e
 return out
exercises=index(catalog['exercises'],'exercise')
media=index(catalog['mediaAssets'],'media')
routines=index(catalog['routines'],'routine')
for e in exercises.values():
 if (e['posterMediaId'],1) not in media:error(f"Missing poster media for {e['id']}")
 for step in e['steps']:
  f=ROOT/step['framePath']
  if not f.is_file():error(f"Missing frame: {f}")
 if e['reviewStatus']=='approved' and e['demoOnly']:error(f"Approved content cannot be demo-only: {e['id']}")
for m in media.values():
 for f in m['files']:
  dest=(ROOT/f['path']).resolve()
  if not dest.is_relative_to(ROOT.resolve()):error(f'Path escape: {dest}');continue
  if not dest.is_file():error(f'Missing media: {dest}');continue
  if dest.stat().st_size!=f['bytes']:error(f'Size mismatch: {dest}')
  real=hashlib.sha256(dest.read_bytes()).hexdigest()
  if real!=f['sha256']:error(f'SHA-256 mismatch: {dest}')
 if m['reviewStatus']=='approved' and m['demoOnly']:error(f"Approved media cannot be demo-only: {m['id']}")
for r in routines.values():
 seconds=0
 seq=[]
 for s in r['steps']:
  e=exercises.get((s['exerciseId'],s['exerciseVersion']))
  if e is None:error(f"Missing exercise {s['exerciseId']} at v{s['exerciseVersion']} in {r['id']}")
  elif r['reviewStatus']=='approved' and (e['reviewStatus']!='approved' or e['demoOnly']):error(f"Approved routine references non-approved exercise: {r['id']} -> {e['id']}")
  seq.append(s['order']);seconds+=s['durationSeconds']
 if seq!=list(range(1,len(seq)+1)):error(f"Steps not sorted/contiguous: {r['id']}")
 if seconds!=r['totalDurationSeconds']:error(f"Duration mismatch: {r['id']}: {seconds} != {r['totalDurationSeconds']}")
 if r['reviewStatus']=='approved' and r['demoOnly']:error(f"Approved routine cannot be demo-only: {r['id']}")
if catalog['status']=='published':
 if catalog.get('demoOnly'):error('Published catalog cannot be demoOnly')
 for group in [catalog['exercises'],catalog['routines'],catalog['mediaAssets']]:
  for o in group:
   if o['reviewStatus']!='approved' or o['demoOnly']:error('Published catalog includes unapproved or demo-only item: '+o['id'])
if errors:
 print('FAILED: '+str(len(errors))+' issues',file=sys.stderr)
 for e in errors:print(' - '+e,file=sys.stderr)
 raise SystemExit(1)
print('PASS: catalog schema/references/durations/image hashes + publication gates',len(exercises),'exercises,',len(routines),'routines,',len(media),'media collections')
