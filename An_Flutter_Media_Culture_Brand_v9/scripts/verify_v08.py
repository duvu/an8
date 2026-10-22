#!/usr/bin/env python3
"""Integrity and strict release safety gate for An Nhien Media v0.8."""
import argparse, json, csv, hashlib, sys
from pathlib import Path
BASE=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--integrity',action='store_true')
    parser.add_argument('--release',action='store_true')
    args=parser.parse_args()
    obj=json.loads((BASE/'assets/catalog/media_delivery_status.v0.8.json').read_text(encoding='utf-8'))
    mistakes=[]
    for eid,e in obj['exercises'].items():
        if not (BASE/e['listing']).is_file():mistakes.append('missing listing: '+eid)
        for fr in e['existingFrames']:
            if not (BASE/fr).is_file():mistakes.append('missing frame: '+eid+' '+fr)
    with (BASE/'media_manifest_v08.csv').open(encoding='utf-8-sig',newline='') as f:
        for x in csv.DictReader(f):
            p=BASE/x['path']
            if not p.is_file():mistakes.append('missing ledger file: '+x['path']);continue
            if p.stat().st_size!=int(x['bytes']):mistakes.append('size mismatch: '+x['path'])
            if hashlib.sha256(p.read_bytes()).hexdigest()!=x['sha256']:mistakes.append('checksum mismatch: '+x['path'])
    if mistakes:
        print('INTEGRITY FAILURE: '+str(len(mistakes)))
        print('\n'.join(mistakes[:30]))
        return 1
    print('INTEGRITY PASS: 67 exercises and media ledger verified')
    if args.release:
        blocks=[]
        for eid,e in obj['exercises'].items():
            if not e['approved']:blocks.append(eid+' has no expert review')
            if not e['video']:blocks.append(eid+' final video missing')
            if not e['recordedVoice']:blocks.append(eid+' final Vietnamese voice missing')
            if not e['synchronizedVtt']:blocks.append(eid+' synced subtitle missing')
        for eid in ('E04','E06'):
            blocks.append(eid+' known unsafe/incorrect visual instruction')
        print('RELEASE BLOCKED: '+str(len(blocks))+' unmet checks')
        print('Examples: '+ '; '.join(blocks[:6]))
        return 2
    return 0
if __name__=='__main__':sys.exit(main())
