# 09 — Prompt Suno: 6 bản nhạc nền An Nhiên

**Cách nhập trong Suno (chế độ Custom):**
- Bật **Instrumental**.
- Dán cột **Style** vào ô *Style of Music*, cột **Exclude** vào ô *Exclude styles* (nếu bản Suno của bạn có ô này).
- Dán khối **Lyrics/Structure** vào ô *Lyrics*. Các thẻ trong ngoặc vuông giúp Suno giữ cấu trúc êm, không cao trào.
- Mỗi bản tạo 2–4 lần, chọn bản đều nhất. Bản đạt yêu cầu: không có giọng hát, không có trống mạnh, không đột ngột to lên.

**Sau khi tải về** (Suno không đảm bảo vòng lặp liền mạch):
1. Cắt 2–3 phút ổn định nhất, tạo vòng lặp có crossfade 2–3 giây.
2. Chuẩn hóa về −23 LUFS, xuất M4A (AAC) 48 kHz stereo, đặt tên đúng cột **File**.
3. Đặt vào `assets/audio/music/`.

**Bản quyền:** kiểm tra điều khoản Suno hiện hành trước khi dùng. Bản tạo bằng gói miễn phí thường không được dùng thương mại; cần tạo bằng gói trả phí. Ghi gói, ngày tạo và link bài vào `media_manifest.csv`.

---

## M1 — Buổi sáng (R01–R04, bộ cơ bản) · `music_morning.m4a`

**Title:** An Nhien Morning

**Style:**
```text
gentle Vietnamese meditation, dan tranh zither, bamboo flute, soft warm pad, D major pentatonic, 62 bpm, sparse calm melody, hopeful morning, ambient, instrumental, no vocals
```

**Exclude:** `vocals, drums, percussion, EDM, cinematic build-up, distorted, fast tempo`

**Lyrics/Structure:**
```text
[Instrumental]
[Intro: soft pad, single zither notes]
[Theme: bamboo flute, slow, breathing phrases]
[Theme variation: zither and flute, very gentle]
[Outro: pad fades softly]
```

## M2 — Buổi tối, chế độ xem từ xa (R05) · `music_evening.m4a`

**Title:** An Nhien Evening

**Style:**
```text
warm evening relaxation ambient, low soft pads, distant singing bowl, sparse low piano, 52 bpm, dark warm tone, sleepy and safe, minimal, instrumental, no vocals
```

**Exclude:** `vocals, drums, bright synth, high-pitched bells, sudden changes, cinematic`

**Lyrics/Structure:**
```text
[Instrumental]
[Intro: low pad swell]
[Ambient: sparse low piano notes, distant singing bowl every 16 bars]
[Ambient: same mood, even softer]
[Outro: long fade]
```

## M3 — Khí công (Bát Đoạn Cẩm, Dịch Cân Kinh) · `music_qigong.m4a`

**Title:** Qigong Mountain Breath

**Style:**
```text
traditional East Asian qigong music, guqin, xiao flute, soft drone, 58 bpm, slow 8-second breathing phrases, serene mountain atmosphere, meditative, instrumental, no vocals
```

**Exclude:** `vocals, drums, gong crash, epic orchestra, fast tempo, modern beat`

**Lyrics/Structure:**
```text
[Instrumental]
[Intro: drone and single guqin pluck]
[Theme: xiao flute long notes, inhale-exhale phrasing]
[Theme: guqin answers flute, calm]
[Outro: drone fades]
```

## M4 — Ngũ Cầm Hí · `music_five_animals.m4a`

**Title:** Five Animals Garden

**Style:**
```text
light playful East Asian nature music, pipa plucks, bamboo flute, very soft wooden percussion, gentle forest ambience, 68 bpm, cheerful but calm, instrumental, no vocals
```

**Exclude:** `vocals, loud drums, EDM, hip hop, aggressive, fast tempo`

**Lyrics/Structure:**
```text
[Instrumental]
[Intro: forest ambience, soft pipa]
[Theme: flute melody, light wood blocks very quiet]
[Theme variation: pipa and flute, playful but gentle]
[Outro: ambience fades]
```

## M5 — Lục Tự Quyết (nên mặc định tắt) · `music_six_sounds.m4a`

**Title:** Six Sounds Drone

**Style:**
```text
minimal ambient drone, single warm low tone, slow gentle swells, almost silent, no melody, leaves space for spoken breathing sounds, meditative, instrumental, no vocals
```

**Exclude:** `melody, vocals, drums, bells, piano, flute, rhythm`

**Lyrics/Structure:**
```text
[Instrumental]
[Drone: low warm tone]
[Drone: very slow swell and release]
[Drone: steady, quiet]
```

## M6 — Thái Cực 24 thức · `music_taichi.m4a`

**Title:** Flowing Tai Chi

**Style:**
```text
flowing tai chi music, guqin and erhu long sustained phrases, soft pad, 55 bpm, continuous like water, peaceful, no sudden changes, instrumental, no vocals
```

**Exclude:** `vocals, drums, percussion, epic, dramatic, fast tempo, electronic beat`

**Lyrics/Structure:**
```text
[Instrumental]
[Intro: pad and guqin]
[Theme: erhu long phrases, smooth]
[Theme: guqin and erhu together, like flowing water]
[Outro: soft fade]
```

---

**Đưa vào app:** app chưa phát nhạc nền. Cần làm thêm trong T06:
- phát nhạc theo bài, lặp liền mạch;
- hạ nhạc 10–12 dB khi có giọng đọc hoặc âm báo;
- công tắc "Nhạc nền" trong Cài đặt;
- tạm dừng cùng phiên tập.
