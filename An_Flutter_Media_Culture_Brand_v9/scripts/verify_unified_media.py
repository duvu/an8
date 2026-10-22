#!/usr/bin/env python3
from pathlib import Path
import hashlib, json,sys
root=Path(__file__).resolve().parents[1]
reg=json.loads((root/'assets/catalog/visual_registry.v1.json').read_text(encoding='utf8'))['exercises']
issues=[]
for eid,x in reg.items():
 path=(root/('packages/an_nhien_eastern_content/'+x['coverPath'] if eid.startswith(('E1','E2','E3','E4','E5')) else x['coverPath']))
 if not path.exists():issues.append('missing cover '+eid)
 if x['isInstructional'] or x['coverStatus']=='approved':issues.append('incorrect approval claim '+eid)
for eid in ['E04','E06']:
 if eid not in reg or reg[eid]['instructionFramesStatus']!='known_issue':issues.append('missing blocker '+eid)
assert len(reg)==67, f'expected 67 got {len(reg)}'
if issues:
 print('FAILED',*issues,sep='\n- ');sys.exit(1)
print('VISUAL INTEGRITY PASS: 67 cards, draft flags, explicit E04/E06 blockers')
print('RELEASE BLOCKED: no verified 67 exercise videos, no expert-review signoffs.')
