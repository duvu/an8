from PIL import Image, ImageDraw, ImageFont
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
F=Path('/usr/share/fonts/truetype/noto/NotoSans-Bold.ttf')
font=lambda n:ImageFont.truetype(str(F),n)
card_w,card_h=324,432
sheet=Image.new('RGB',(1500,1210),'#F8F8F1')
d=ImageDraw.Draw(sheet)
d.rectangle((0,0,1500,155),fill='#073F3B')
d.text((70,30),'AN NHIÊN',font=font(49),fill='white')
d.text((70,99),'7 SERIES ĐỘNG TÁC · 14 PHÚT · ASSETS TÁCH RIÊNG',font=font(22),fill='#E1ECDD')
for i in range(7):
    img=Image.open(ROOT/'assets/series'/f'E{i+1:02d}'/'thumbnail.png').convert('RGB')
    img=img.resize((card_w,card_h),Image.Resampling.LANCZOS)
    x=58+(i%4)*364;y=198+(i//4)*472
    sheet.paste(img,(x,y))
    d.rounded_rectangle((x-1,y-1,x+card_w,y+card_h),radius=12,outline='#B2C8BF',width=2)
d.text((70,1147),'HÌNH AI MINH HỌA · CHƯA ĐƯỢC CHUYÊN GIA KIỂM DUYỆT',font=font(24),fill='#704E2A')
sheet.save(ROOT.parent/'An_Nhien_7_Series_Preview.png',optimize=True)
print('preview created')
