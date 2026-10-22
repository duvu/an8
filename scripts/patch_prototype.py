from pathlib import Path
import json,re
root=Path(__file__).resolve().parents[1]
p=root/'04_Wireframe_Interactive.html';html=p.read_text()
content=json.loads((root/'catalog/catalog.v1.json').read_text())
e_names={e['id']:e['title'] for e in content['exercises']}
icons={'R01':'☀','R02':'❀','R03':'✿','R04':'⌑','R05':'☾'}
positions={'R01':'Ngồi / đứng','R02':'Đứng / ngồi','R03':'Ngồi','R04':'Ngồi','R05':'Ngồi'}
new=[]
for r in content['routines']:
    new.append({'id':r['id'],'title':r['title'],'minutes':r['totalDurationSeconds']//60,'position':positions[r['id']],
                'description':r['description'],'steps':[e_names[s['exerciseId']] for s in r['steps']],
                'exerciseIds':[s['exerciseId'] for s in r['steps']],
                'stepDurations':[s['durationSeconds'] for s in r['steps']],
                'icon':icons[r['id']],'starter':r['id']=='R01'})
html=re.sub(r'const routines=\[.*?\];\nconst names=', 'const routines='+json.dumps(new,ensure_ascii=False)+';\nconst names=',html,count=1,flags=re.S)
# IDs are validated against allowed dataset; this prototype only references local trusted files.
replace='''function art(cl='',exId='E01'){
 const img=`assets/series/${exId}/thumbnail.png`;
 return `<div class="${cl||'hero-media'} demo-image"><img src="${img}" alt="Ảnh storyboard minh họa AI cho động tác ${exId}, chưa kiểm duyệt" loading="lazy"/><span class="placeholder-label">MINH HỌA AI • DRAFT</span><span class="media-badge">Chờ chuyên gia kiểm duyệt</span></div>`;
}'''
html=re.sub(r"function art\(cl=''\)\{return .*?\}\nfunction head",replace+'\nfunction head',html,count=1,flags=re.S)
html=html.replace("function routineCard(r){let ready", "function routineCard(r){let ready")
html=html.replace("${art('media')}<div class=\"row\">", "${art('media',r.exerciseIds[0])}<div class=\"row\">")
html=html.replace("${art('media large')}<div class=\"eyebrow\">ĐANG TẬP THEO", "${art('media large',r.exerciseIds[st.step])}<div class=\"eyebrow\">ĐANG TẬP THEO")
html=html.replace("let dur=Math.round(r.minutes*60/total);let rem=", "let dur=r.stepDurations[st.step];let rem=")
html=html.replace("let frac=Math.min(.99,(st.step+st.seconds/dur)/total);", "let elapsed=r.stepDurations.slice(0,st.step).reduce((a,b)=>a+b,0)+st.seconds;let frac=Math.min(.99,elapsed/(r.minutes*60));")
html=html.replace("r.minutes*60-st.step*dur-st.seconds", "r.minutes*60-elapsed")
html=html.replace("let dur=Math.round(rt().minutes*60/rt().steps.length);st.seconds++", "let dur=rt().stepDurations[st.step];st.seconds++")
html=html.replace('--ink:#24352c;--muted:#6d7971;--leaf:#426c59;--leaf2:#5c8772;', '--ink:#173B34;--muted:#5e766d;--leaf:#0B554B;--leaf2:#0E685E;')
html=html.replace('.media-symbol{', '.demo-image img{height:100%;width:100%;object-fit:cover;object-position:center 31%;opacity:.92}.media-symbol{')
html=html.replace('● Media minh họa, không phải nội dung sức khỏe đã duyệt.', '● Ảnh series AI tách riêng E01–E07; DRAFT, chưa kiểm duyệt.')
html=html.replace('video chỉ là ô minh họa.', 'hình series là bản AI minh họa chưa duyệt.')
html=html.replace('Media 16:9 — đây chỉ là placeholder','Ảnh series trong Player chỉ là minh họa draft')
html=html.replace('Cần thay bằng media đã kiểm duyệt','DRAFT · chờ media kiểm duyệt')
p.write_text(html)
print('Updated',p)
