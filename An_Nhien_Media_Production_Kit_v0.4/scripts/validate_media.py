#!/usr/bin/env python3
"""Validate An Nhien media requirements; never silently promote draft media."""
from pathlib import Path
from PIL import Image
import csv, argparse, hashlib, subprocess, json, sys
parser=argparse.ArgumentParser()
parser.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1])
parser.add_argument('--mode',choices=['inventory','release'],default='inventory')
args=parser.parse_args()
root=args.root
rows=list(csv.DictReader(open(root/'media_manifest.csv',encoding='utf-8-sig')))
missing=[]; errors=[]; pending=[]; ready=0
for r in rows:
    p=root/r['path']
    if not p.exists():
        missing.append(r['path']); continue
    if r['width'] and r['height'] and r['asset_type'] in ('icon','pose-frame','chair-pose-frame','cover'):
        try:
            with Image.open(p) as img:
                if img.size!=(int(r['width']),int(r['height'])):
                    errors.append(f'Wrong dimensions: {p} got {img.size}')
        except Exception as e: errors.append(f'Invalid image: {p}: {e}')
    if r['sha256']:
        digest=hashlib.sha256(p.read_bytes()).hexdigest()
        if digest!=r['sha256']:errors.append(f'Checksum mismatch: {p}')
    if r['asset_type']=='video':
        try:
            proc=subprocess.run(['ffprobe','-v','error','-show_streams','-of','json',str(p)],capture_output=True,text=True,check=True)
            streams=json.loads(proc.stdout)['streams']
            vs=next(s for s in streams if s['codec_type']=='video')
            audio=next((s for s in streams if s['codec_type']=='audio'),None)
            if vs['codec_name']!='h264' or vs['width']!=1920 or vs['height']!=1080:errors.append(f'Video format mismatch: {p}')
            if not audio or audio['codec_name']!='aac' or audio.get('sample_rate')!='48000':errors.append(f'Audio track mismatch: {p}')
        except Exception as e: errors.append(f'Invalid video: {p}: {e}')
    if r['asset_type']=='audio':
        try:
            proc=subprocess.run(['ffprobe','-v','error','-select_streams','a:0','-show_entries','stream=sample_rate,channels','-of','json',str(p)],capture_output=True,text=True,check=True)
            aud=json.loads(proc.stdout)['streams'][0]
            if aud['sample_rate']!='48000':errors.append(f'Audio sample rate mismatch: {p}')
        except Exception as e:errors.append(f'Invalid audio: {p}: {e}')
    if r['status'] not in ['approved','published'] or not r['license'] or not r['reviewer'] or not r['review_date']:
        pending.append(r['path'])
    else:ready+=1
print(json.dumps({'inventory':len(rows),'present':len(rows)-len(missing),'missing':len(missing),'errors':errors[:30],'not_release_approved':len(pending),'ready':ready},ensure_ascii=False,indent=2))
if errors or (args.mode=='release' and (missing or pending)):
    sys.exit(1)
