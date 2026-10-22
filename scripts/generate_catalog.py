#!/usr/bin/env python3
"""Creates the published content manifest from separate exercise series."""
from pathlib import Path
import hashlib,json,importlib.util
ROOT=Path(__file__).resolve().parents[1]
sp=importlib.util.spec_from_file_location('build_series_assets',ROOT/'scripts/build_series_assets.py')
module=importlib.util.module_from_spec(sp);sp.loader.exec_module(module)
items=module.ITEMS

def meta(path):
    src=ROOT/path
    return {'path':path.as_posix(),'bytes':src.stat().st_size,'sha256':hashlib.sha256(src.read_bytes()).hexdigest()}

EX=[];MEDIA=[]
for x in items:
    sub=Path('assets/series')/x['id']
    posterid=f'{x["id"]}-STORYBOARD-v1'
    mediafiles=[meta(sub/'storyboard.png'),meta(sub/'thumbnail.png'),meta(sub/'series_strip.png')]
    for ix,_ in enumerate(x['frames'],1): mediafiles.append(meta(sub/'frames'/f'{ix:02d}.png'))
    MEDIA.append({'id':posterid,'version':1,'kind':'storyboard','locale':'vi-VN','files':mediafiles,
      'reviewStatus':'approved','demoOnly':False,'aiGenerated':True,
      'rights':'Ảnh minh họa tạo bằng AI; chủ sản phẩm quyết định dùng làm nội dung chính thức ngày 2026-10-18 (chưa có kiểm duyệt chuyên môn hay rà soát bản quyền độc lập).',
      'accessibilityDescription':f'Series ảnh hướng dẫn {x["title"]}.'})
    EX.append({'id':x['id'],'version':1,'locale':'vi-VN','title':x['title'],'defaultDurationSeconds':x['minutes']*60,
       'position':('seated' if x['id'] in ('E01','E03','E07') else 'standing'),
       'intensity':'gentle','tags':['gentle','beginner'],
       'reviewStatus':'approved','demoOnly':False,'safetyNotes':[x['safety']],
       'steps':[{'order':i+1,'instruction':s,'framePath':(sub/'frames'/f'{i+1:02d}.png').as_posix()} for i,s in enumerate(x['steps'])],
       'posterMediaId':posterid,'mediaAssetIds':[posterid]})
DUR={x['id']:x['minutes']*60 for x in items}
def routine(id,title,summary,tag,steps):
    return {'id':id,'version':1,'locale':'vi-VN','title':title,'description':summary,'tags':tag,
       'reviewStatus':'approved','demoOnly':False,
       'totalDurationSeconds':sum(s for _,s in steps),
       'steps':[{'order':i+1,'exerciseId':e,'exerciseVersion':1,'durationSeconds':s,'mediaVariant':'storyboard'} for i,(e,s) in enumerate(steps)]}
R=[
 routine('R01','Khởi động nhẹ','Làm quen với hơi thở, vận động vai và thư giãn.',['starter','gentle'],[('E01',120),('E02',120),('E07',120)]),
 routine('R02','Dưỡng sinh sáng 14 phút','Chuỗi 7 động tác nhẹ theo thứ tự.',['morning','gentle'],[(x['id'],DUR[x['id']]) for x in items]),
 routine('R03','Thư giãn cổ vai 8 phút','Tập vai, tay và thư giãn, không ấn vào cổ trước.',['neck-shoulder','seated'],[('E02',120),('E04',120),('E03',120),('E07',120)]),
 routine('R04','Dưỡng sinh trên ghế 10 phút','Bài ngồi nhẹ cho tay, chân, vai và hơi thở.',['seated'],[('E01',120),('E03',180),('E02',120),('E04',120),('E07',60)]),
 routine('R05','Thư giãn buổi tối 6 phút','Thở tự nhiên và ngồi thư giãn.',['evening','seated'],[('E01',120),('E07',240)]),
]

# Bát Đoạn Cẩm (D13): published by the product owner on 2026-10-18 from the v0.3
# step photos in packages/an_nhien_eastern_content. Wording is transcribed from
# each form's poster (03_poster_instruction.webp) so text matches the photos.
EASTERN_PKG=Path('packages/an_nhien_eastern_content/assets/series')
BADUANJIN=[
 ('E101','Hai tay nâng trời',['Đứng thẳng, thả lỏng.','Nâng tay lên phía trước.','Đưa tay lên cao, lòng bàn tay hướng trời.','Hạ tay xuống về vị trí ban đầu.'],
  'Vai thả lỏng, không rướn cổ.','Hít vào khi nâng tay, thở ra khi hạ tay; lặp lại 6–8 lần.'),
 ('E102','Kéo cung bắn chim ưng',['Đứng tấn nhẹ, chuẩn bị.','Mở tay trái, kéo cung.','Đổi bên, kéo cung.','Trở về giữa, thả lỏng.'],
  'Vai hạ thấp, không gồng cổ.','Hít vào khi mở, thở ra khi trở về; lặp lại 4–6 lần mỗi bên.'),
 ('E103','Một tay nâng, một tay ép',['Đứng thẳng, chuẩn bị.','Tay trái nâng, tay phải ép.','Đổi bên, thực hiện lại.','Trở về giữa, thả lỏng.'],
  'Giữ vai mềm, không nghiêng người quá mạnh.','Hít vào khi nâng, thở ra khi đổi; lặp lại 4–6 lần mỗi bên.'),
 ('E104','Quay đầu nhìn sau',['Đứng thẳng, thả lỏng.','Quay sang trái, nhìn sau.','Quay sang phải, nhìn sau.','Trở về giữa, thả lỏng.'],
  'Không vặn cổ mạnh, tránh đau.','Thở tự nhiên, chậm và đều; lặp lại 4–6 lần mỗi bên.'),
 ('E105','Lắc đầu, vẫy đuôi',['Đứng tấn nhẹ, chống tay lên đùi.','Nghiêng sang trái, quay đầu nhẹ.','Nghiêng sang phải, quay đầu nhẹ.','Trở về giữa, giữ thăng bằng.'],
  'Không hạ thấp quá mức, giữ lưng thoải mái.','Thở đều theo chuyển động; lặp lại 4–6 lần mỗi bên.'),
 ('E106','Cúi người chạm chân',['Đứng thẳng, chuẩn bị.','Nâng tay lên, chuẩn bị cúi.','Cúi người chậm, chạm chân.','Đứng thẳng lại, thả lỏng.'],
  'Chỉ cúi trong phạm vi thoải mái, không giật mạnh.','Hít vào khi nâng tay, thở ra khi cúi; lặp lại 4–6 lần.'),
 ('E107','Nắm quyền, đấm nhẹ',['Đứng tấn nhẹ, nắm quyền.','Đấm tay trái, mắt nhìn theo.','Đấm tay phải, mắt nhìn theo.','Thu tay về, thả lỏng.'],
  'Đấm nhẹ, không khóa khuỷu tay.','Thở ra khi đấm, hít vào khi thu tay; lặp lại 4–6 lần mỗi bên.'),
 ('E108','Nhón gót, hạ gót',['Đứng thẳng, chuẩn bị.','Nhón gót lên, giữ thăng bằng.','Giữ nhẹ, thở đều.','Hạ gót xuống, trở về đầu.'],
  'Giữ người ổn định, có thể đứng gần điểm tựa.','Hít vào khi nhón, thở ra khi hạ; lặp lại 6–8 lần.'),
]
STOP_NOTE='Dừng nếu đau, chóng mặt, khó thở hoặc mất thăng bằng.'
for eid,title,steps,care,breath in BADUANJIN:
    sub=EASTERN_PKG/eid
    frames=[sub/f'{i+4:02d}_step_{i+1}.webp' for i in range(4)]
    mid=f'{eid}-STEP-PHOTOS-v1'
    MEDIA.append({'id':mid,'version':1,'kind':'storyboard','locale':'vi-VN','files':[meta(f) for f in frames],
      'reviewStatus':'approved','demoOnly':False,'aiGenerated':True,
      'rights':'Ảnh minh họa tạo bằng AI (gói nội dung phương Đông v0.3/v0.7); chủ sản phẩm duyệt kỹ thuật và quyết định dùng chính thức ngày 2026-10-18 (chưa rà soát bản quyền độc lập).',
      'accessibilityDescription':f'Chuỗi 4 ảnh hướng dẫn thức {title}.'})
    EX.append({'id':eid,'version':1,'locale':'vi-VN','title':title,'defaultDurationSeconds':75,
       'position':'standing','intensity':'easy','tags':['eastern-qigong','baduanjin'],
       'reviewStatus':'approved','demoOnly':False,'safetyNotes':[care,breath,STOP_NOTE],
       'steps':[{'order':i+1,'instruction':t,'framePath':frames[i].as_posix()} for i,t in enumerate(steps)],
       'posterMediaId':mid,'mediaAssetIds':[mid]})
R.append(routine('R101','Bát Đoạn Cẩm 10 phút','Tám thức Bát Đoạn Cẩm theo thứ tự, động tác chậm, biên độ vừa phải.',
                 ['baduanjin','eastern-qigong'],[(eid,75) for eid,*_ in BADUANJIN]))
manifest={'schemaVersion':1,'catalogId':'an-nhien-v1','catalogVersion':'2026.10.18.3','locale':'vi-VN','status':'published','demoOnly':False,
 'contentManagement':{'source':'git-managed-manifest','futureBackend':'CMS/remote catalog supported via ContentCatalogRepository interface','syncEnabled':False},
 'exercises':EX,'routines':R,'mediaAssets':MEDIA}
file=ROOT/'catalog/catalog.v1.json'
file.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print('Wrote',file,':',len(EX),'exercises,',len(R),'routines,',len(MEDIA),'assets')
