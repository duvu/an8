#!/usr/bin/env python3
"""Generate separate visual storyboards from the AI reference master.
This is a deterministic asset-layout utility, not a motion/video generator.
2026-10-18: the "CHƯA KIỂM DUYỆT" banner was removed from posters at the product
owner's decision to use these images as official content (see DECISIONS.md D08).
No expert review has taken place; assets stay marked aiGenerated in the catalog.
After running this script, run scripts/fix_e04_e06.py (E04/E06 re-sequence).
"""
from PIL import Image, ImageDraw, ImageFont, ImageOps
from pathlib import Path
from textwrap import wrap

ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'assets/source/generated_master_contact_sheet.png'
OUT=ROOT/'assets/series'
master=Image.open(SRC).convert('RGB')
assert master.size == (1536,1024), 'Expected original 1536x1024 source'
TEAL='#073F3B'; TEAL2='#0A5249'; DEEP='#052F2C'; CREAM='#FAF9F3'; MINT='#D8EAE2'; WHITE='#FFFFFF'; INK='#123A35'; MUTED='#5C7670'; GOLD='#E9D5A4'
font_root=Path('/usr/share/fonts/truetype/noto')
def font(size,bold=False):
    p=font_root/('NotoSans-Bold.ttf' if bold else 'NotoSans-Regular.ttf')
    return ImageFont.truetype(str(p),size)
def roundrect(draw,xy,fill, radius=28, outline=None,width=1):draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)
def centered(draw,text,y,f,max_width,fill):
    while draw.textbbox((0,0),text,font=f)[2] > max_width and f.size>22:f=font(f.size-1,True)
    w=draw.textbbox((0,0),text,font=f)[2]
    draw.text(((1080-w)//2,y),text,font=f,fill=fill)
def fit_lines(draw,text,f,maxwidth):
    words=text.split();result=[];buf=''
    for w in words:
        cand=(buf+' '+w).strip()
        if draw.textbbox((0,0),cand,font=f)[2]>maxwidth and buf:
            result.append(buf);buf=w
        else:buf=cand
    if buf:result.append(buf)
    return result

def frame_rect(x0,y0,x1,y1): return (x0,y0,x1,y1)
# Frames intentionally cropped from the newly generated consistent dark-green visual series.
ITEMS=[
 dict(id='E01', slug='tho_tu_nhien', title='Thở tự nhiên', minutes=2, region=(7,93,532,426),
    frames=[(17,145,139,308),(146,145,267,308),(273,145,394,308),(400,145,522,308)],
    steps=['Ngồi vững, vai và hàm thả lỏng.','Đặt tay lên bụng nếu thấy dễ chịu.','Hít thở nhẹ theo nhịp tự nhiên.','Tiếp tục thở đều, không nín thở.'],
    safety='Không cố hít quá sâu hoặc nín thở.'),
 dict(id='E02', slug='xoay_vai', title='Xoay vai nhẹ', minutes=2,region=(541,93,1054,427),
    frames=[(549,145,666,309),(670,145,786,309),(793,145,910,309),(916,145,1040,309)],
    steps=['Đứng hoặc ngồi thẳng, thả lỏng vai.','Nhẹ nhàng nâng và đưa vai ra sau.','Tiếp tục vòng xoay nhỏ, chậm.','Hạ vai, thở đều, đổi chiều.'],
    safety='Không xoay mạnh cổ hay giật vai.'),
 dict(id='E03', slug='tay_co_chan',title='Bàn tay và cổ chân',minutes=2,region=(1057,93,1532,427),
    frames=[(1076,161,1215,230),(1223,161,1364,230),(1372,161,1517,230),(1076,295,1215,364),(1223,295,1364,364),(1372,295,1517,364)],
    steps=['Duỗi nhẹ các ngón tay.','Nắm tay vừa phải, không siết chặt.','Mở bàn tay và thả lỏng.','Ngồi vững, nhấc gót chân.','Đổi sang nhấc mũi chân.','Xoay cổ chân nhỏ nếu thoải mái.'],
    safety='Ngừng nếu xuất hiện đau hoặc tê tăng.'),
 dict(id='E04',slug='nang_ha_tay',title='Nâng hạ hai tay',minutes=2,region=(7,428,535,735),
    frames=[(15,479,138,633),(145,479,267,633),(274,479,397,633),(404,479,525,633)],
    steps=['Đứng vững, tay thả lỏng hai bên.','Nâng tay chậm đến mức dễ chịu.','Giữ cổ và vai thả lỏng.','Hạ tay chậm, thở tự nhiên.'],
    safety='Không cần nâng quá đầu; tránh gồng vai.'),
 dict(id='E05',slug='chuyen_trong_tam',title='Chuyển trọng tâm',minutes=2,region=(542,428,1055,736),
    frames=[(552,480,663,632),(673,480,786,632),(793,480,909,632),(918,480,1039,632)],
    steps=['Đứng rộng bằng vai cạnh chỗ vịn.','Chuyển nhẹ trọng lượng sang trái.','Đổi từ từ sang bên phải.','Trở về giữa, giữ nhịp thở đều.'],
    safety='Hai chân luôn chạm sàn; vịn ghế nếu cần.'),
 dict(id='E06',slug='di_bo_tai_cho',title='Đi bộ tại chỗ',minutes=3,region=(1058,428,1532,737),
    frames=[(1075,482,1187,634),(1195,482,1301,634),(1310,482,1416,634),(1423,482,1523,634)],
    steps=['Đứng thẳng gần chỗ vịn.','Nhấc chân phải thấp, nhẹ nhàng.','Đổi sang chân trái và giữ thăng bằng.','Bước đều chậm, hít thở tự nhiên.'],
    safety='Không cần nâng gối cao; dừng nếu choáng.'),
 dict(id='E07',slug='ngoi_thu_gian',title='Ngồi thư giãn',minutes=1,region=(8,742,533,1019),
    frames=[(17,782,138,921),(146,782,268,921),(275,782,397,921),(404,782,522,921)],
    steps=['Ngồi trên ghế chắc chắn, chân chạm sàn.','Giữ lưng thoải mái, thở tự nhiên.','Buông lỏng vai, hàm và bàn tay.','Ngồi yên một lúc, chú ý hơi thở.'],
    safety='Không ép hoặc điều khiển nhịp thở quá mức.'),
]

def make_poster(data,frames):
    # Phone-friendly original asset designed with a consistent dark-green system.
    pic=Image.new('RGB',(1080,1440),TEAL)
    d=ImageDraw.Draw(pic)
    d.rectangle((0,0,1080,230),fill=DEEP)
    d.ellipse((900,-205,1260,155), fill=TEAL2)
    d.text((55,45),f'SERIES {int(data["id"][1:])}',font=font(27,True),fill=MINT)
    d.text((55,89),data['title'],font=font(55,True),fill=WHITE)
    d.text((55,167),f'{data["minutes"]} phút  •  Vận động nhẹ',font=font(27),fill='#D0E5DE')
    roundrect(d,(32,256,1048,1215),CREAM,30)
    n=len(frames)
    rows=2 if n<=4 else 3;cols=2
    cellw=482;cellh=430 if rows==2 else 287
    top=273
    for i,fr in enumerate(frames):
        x=48+(i%2)*496;y=top+(i//2)*(cellh+11)
        roundrect(d,(x,y,x+cellw,y+cellh),'#E8F0EA',20)
        photo_area=(cellw-24, cellh-(112 if rows==2 else 96))
        scaled=ImageOps.contain(fr,photo_area,Image.Resampling.LANCZOS)
        px=x+(cellw-scaled.width)//2;py=y+12+(photo_area[1]-scaled.height)//2
        pic.paste(scaled,(px,py));d=ImageDraw.Draw(pic)
        roundrect(d,(x+12,y+12,x+61,y+61),TEAL,24)
        d.text((x+27,y+14),str(i+1),font=font(28,True),fill=WHITE)
        label_y=y+cellh-(99 if rows==2 else 82)
        f=font(23 if rows==2 else 21,True)
        lines=fit_lines(d,data['steps'][i],f,cellw-38)[:3]
        for j,line in enumerate(lines):d.text((x+19,label_y+j*32),line,font=f,fill=INK)
    # Bottom safety note
    d.text((50,1232),'LƯU Ý',font=font(22,True),fill='#D2E5DD')
    f=font(28)
    lines=fit_lines(d,data['safety'],f,970)
    for j,line in enumerate(lines[:2]):d.text((50,1267+j*40),line,font=f,fill=WHITE)
    return pic

def main():
    OUT.mkdir(parents=True,exist_ok=True)
    for data in ITEMS:
        dest=OUT/data['id'];(dest/'frames').mkdir(parents=True,exist_ok=True)
        region=master.crop(data['region']);region.resize((1024,round(region.height*1024/region.width)),Image.Resampling.LANCZOS).save(dest/'series_strip.png',optimize=True)
        frames=[]
        for ix,rect in enumerate(data['frames'],1):
            f=master.crop(rect)
            # Individual photo stage independently addressable by player/storyboard; no overlay text.
            canvas=Image.new('RGB',(680,680),CREAM)
            im=ImageOps.contain(f,(650,630),Image.Resampling.LANCZOS)
            canvas.paste(im,((680-im.width)//2,(680-im.height)//2))
            canvas.save(dest/'frames'/f'{ix:02d}.png',optimize=True)
            frames.append(f)
        poster=make_poster(data,frames)
        poster.save(dest/'storyboard.png',optimize=True)
        poster.resize((540,720),Image.Resampling.LANCZOS).save(dest/'thumbnail.png',optimize=True)
        print(data['id'],len(frames),'frames')
    # R02 total routine overview crop (caption/logo from source retained; only design-reference)
    seq=master.crop((540,738,1531,1021))
    seq.resize((1480,423),Image.Resampling.LANCZOS).save(ROOT/'assets'/'R02_sequence_overview.png', optimize=True)

if __name__ == "__main__":
    main()
