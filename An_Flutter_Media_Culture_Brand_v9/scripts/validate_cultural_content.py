#!/usr/bin/env python3
import json, pathlib, csv, re
root=pathlib.Path(__file__).resolve().parents[1]
assets=root/'packages'/'an_nhien_cultural_content'/'assets'
load=lambda p:json.loads((assets/p).read_text(encoding='utf-8'))
systems=load('catalog/systems.vi.v1.json')['systems']
stories=load('catalog/exercise_stories.vi.v1.json')['exercises']
episodes=load('catalog/speaker_episodes.vi.v1.json')['episodes']
sysids={s['id'] for s in systems}
ids=[e['exerciseId'] for e in stories]
assert len(ids)==67 and len(set(ids))==67,(len(ids),'duplicate IDs')
assert len(systems)==7 and len(episodes)==6
assert all(e['systemId'] in sysids for e in stories)
assert all(e['status']=='editorial_draft' and e['isMovementInstruction'] is False and e['audioStatus']=='script_only' for e in stories)
assert all(e['narratorVoiceFile'] is None for e in stories)
assert all((assets/'narration'/'exercises'/(e['exerciseId']+'.vi.txt')).exists() for e in stories)
for e in episodes:assert (root/'packages'/'an_nhien_cultural_content'/e['scriptAssetPath']).exists()
sources=load('sources/references.vi.v1.json')['items']; sourceids={s['id'] for s in sources}
assert all(set(s['sourceIds'])<=sourceids for s in systems)
assert all(set(s['sourceIds'])<=sourceids for s in stories)
with (root/'narration_manifest.csv').open(encoding='utf-8') as f:
 rows=list(csv.DictReader(f));assert len(rows)==80,len(rows)
print(f'PASS: {len(stories)} exercise stories, {len(systems)} system dossiers, {len(episodes)} episodes, {len(rows)} voice scripts, {len(sources)} sources. No completed voice audio asserted.')
