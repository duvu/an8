from pathlib import Path
import hashlib, json, sys
from jsonschema import Draft202012Validator
root = Path(__file__).resolve().parents[1]
assets = root/'packages'/'an_nhien_eastern_content'/'assets'
schema = json.loads((root/'schema'/'catalog.schema.v1.json').read_text(encoding='utf-8'))
errors=[]
exercise_ids=[]; routine_ids=[]; media_ids=[]
for f in sorted((assets/'catalog').glob('*.draft.v1.json')):
    data=json.loads(f.read_text(encoding='utf-8'))
    try: Draft202012Validator(schema).validate(data)
    except Exception as e: errors.append(f'{f.name}: schema invalid {e}')
    assert data['demoOnly'] and data['status']=='draft'
    es={e['id']:e for e in data['exercises']}
    ms={m['id']:m for m in data['mediaAssets']}
    for e in data['exercises']:
        exercise_ids.append(e['id'])
        assert e['reviewStatus']=='draft' and e['demoOnly'] is True
        assert e['posterMediaId'] in ms
        for s in e['steps']:
            if not (root/'packages'/'an_nhien_eastern_content'/s['framePath']).exists(): errors.append(f'missing frame {s["framePath"]}')
    for m in data['mediaAssets']:
        media_ids.append(m['id'])
        for info in m['files']:
            path=root/'packages'/'an_nhien_eastern_content'/info['path']
            if not path.exists(): errors.append(f'missing media {path}');continue
            if path.stat().st_size!=info['bytes']:errors.append(f'bad size {path}')
            if hashlib.sha256(path.read_bytes()).hexdigest()!=info['sha256']:errors.append(f'bad hash {path}')
    for r in data['routines']:
        routine_ids.append(r['id'])
        assert r['reviewStatus']=='draft' and r['demoOnly'] is True
        if sum(s['durationSeconds'] for s in r['steps'])!=r['totalDurationSeconds']:errors.append(f'wrong duration {r["id"]}')
        for s in r['steps']:
            if s['exerciseId'] not in es:errors.append(f'broken link {s["exerciseId"]}')
if len(exercise_ids)!=len(set(exercise_ids)):errors.append('duplicate exercise IDs')
if len(routine_ids)!=len(set(routine_ids)):errors.append('duplicate routine IDs')
if len(media_ids)!=len(set(media_ids)):errors.append('duplicate media IDs')
if set(exercise_ids)&{f'E{i:02d}' for i in range(1,8)}:errors.append('collides with MVP v1.1')
index=json.loads((assets/'catalog'/'index.v1.json').read_text(encoding='utf-8'))
if sum(x['exerciseCount'] for x in index['practiceSystems'])!=len(exercise_ids):errors.append('index counts mismatch')
if errors:
 print('FAILED:', *errors,sep='\n - ');sys.exit(1)
print(f'PASS: {len(index["practiceSystems"])} systems, {len(routine_ids)} draft routines, {len(exercise_ids)} draft exercises, {len(media_ids)} demo media cards. No approved/published content.')
