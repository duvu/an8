#!/usr/bin/env python3
"""Explicit opt-in label/icon update for a real Flutter app. Backs up changed files.
Usage: python scripts/apply_an_branding.py /path/to/flutter/app --apply
Without --apply, displays the intended paths without modifying anything.
"""
from pathlib import Path
import argparse, plistlib, re, shutil
p=argparse.ArgumentParser()
p.add_argument('app', help='Path containing pubspec.yaml, android/, ios/')
p.add_argument('--apply',action='store_true')
a=p.parse_args();app=Path(a.app).resolve()
root=Path(__file__).resolve().parent.parent
assert (app/'pubspec.yaml').exists(), 'Expected Flutter application root'
patches=[]
def edit(path, func):
    if not path.exists():return
    original=path.read_bytes(); updated=func(original)
    if updated!=original:
        patches.append(str(path))
        if a.apply:
            backup=path.with_name(path.name+'.before_an_brand.bak')
            if not backup.exists():shutil.copyfile(path,backup)
            path.write_bytes(updated)

def android_change(data):
    text=data.decode('utf-8')
    # replace application label only, not the package namespace
    text=re.sub(r'android:label="[^"]*"','android:label="An"',text,count=1)
    return text.encode('utf-8')
edit(app/'android/app/src/main/AndroidManifest.xml',android_change)
def ios_change(data):
    d=plistlib.loads(data)
    d['CFBundleDisplayName']='An'
    d['CFBundleName']='An'
    return plistlib.dumps(d)
edit(app/'ios/Runner/Info.plist',ios_change)
def web_change(data):
    text=data.decode('utf-8')
    text=re.sub(r'<title>.*?</title>','<title>An</title>',text,flags=re.S)
    text=re.sub(r'(<meta[^>]+name="apple-mobile-web-app-title"[^>]+content=")[^"]*',r'\g<1>An',text)
    return text.encode('utf-8')
edit(app/'web/index.html',web_change)
def web_manifest(data):
    import json
    d=json.loads(data)
    d['name']='An';d['short_name']='An'
    return (json.dumps(d,ensure_ascii=False,indent=2)+'\n').encode('utf-8')
edit(app/'web/manifest.json',web_manifest)
source=root/'branding/platform'
copy_dirs=[
    (source/'android/res',app/'android/app/src/main/res'),
    (source/'ios/AppIcon.appiconset',app/'ios/Runner/Assets.xcassets/AppIcon.appiconset'),
]
for src,dest in copy_dirs:
    for f in src.rglob('*'):
        if not f.is_file():continue
        target=dest/f.relative_to(src)
        patches.append(str(target))
        if a.apply:
            target.parent.mkdir(parents=True,exist_ok=True)
            if target.exists():
                bak=target.with_name(target.name+'.before_an_brand.bak')
                if not bak.exists():shutil.copy2(target,bak)
            shutil.copy2(f,target)
print(('APPLIED' if a.apply else 'DRY RUN')+': '+str(len(patches))+' edits/copies')
for f in patches:print(f)
print('NEXT: add an_brand package dependency to pubspec.yaml; update header/player Widgets to use AnLockup and AnVideoBrandOverlay; run flutter test and verify on devices.')
