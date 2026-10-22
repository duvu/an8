## 6. Nhạc nền (6 bản)

**Yêu cầu chung cho mọi bản:**
- Không lời; vòng lặp liền mạch 2–3 phút; 48 kHz stereo; −23 LUFS (nhạc nền).
- Không đổi nhịp hay cao trào đột ngột.
- Chừa dải giọng nói 1–4 kHz: giai điệu thưa, nhạc cụ trầm ấm.
- Khi có giọng đọc, app hạ nhạc thêm 10–12 dB (ducking).
- Có giấy phép dùng thương mại trong ứng dụng.

| Mã | Dùng cho | Tempo | Prompt cho công cụ tạo nhạc |
|---|---|---:|---|
| M1 `music_morning` | R01–R04, bộ cơ bản | 60–66 BPM | "Gentle Vietnamese-inspired morning meditation music, đàn tranh (zither) and bamboo flute (sáo trúc) over a soft warm pad, D major pentatonic, sparse melody, calm and hopeful, seamless loop, no vocals, no drums" |
| M2 `music_evening` | R05, chế độ xem từ xa buổi tối | 50–56 BPM | "Warm evening relaxation ambient, low soft pads, occasional distant singing bowl, very sparse low-register piano, no high frequencies, sleepy and safe, seamless loop, no vocals, no percussion" |
| M3 `music_qigong` | Bát Đoạn Cẩm, Dịch Cân Kinh | 56–60 BPM | "Traditional East Asian qigong practice music, guqin and xiao flute with soft drone, slow breathing phrases of 8 seconds, serene mountain atmosphere, seamless loop, no vocals" |
| M4 `music_five_animals` | Ngũ Cầm Hí | 66–72 BPM | "Light playful East Asian nature music, pipa plucks and bamboo flute, very soft wooden percussion, gentle forest ambience, cheerful but calm, seamless loop, no vocals" |
| M5 `music_six_sounds` | Lục Tự Quyết | không nhịp | "Minimal ambient drone, single warm low tone with slow gentle swells, almost silent, leaves full space for spoken breathing sounds, seamless loop, no melody, no vocals" (nên mặc định **tắt** nhạc cho hệ này) |
| M6 `music_taichi` | Thái Cực 24 thức | 52–58 BPM | "Flowing tai chi music, guqin and erhu long sustained phrases over soft pad, continuous like water, no sudden changes, seamless loop, no vocals, no drums" |

**Prompt cho ChatGPT** (khi cần biến tấu hoặc chuyển sang công cụ khác):

```text
Viết mô tả chi tiết (bằng tiếng Anh, ≤ 60 từ) cho công cụ tạo nhạc AI để tạo nhạc nền
dưỡng sinh: {mục đích}, tempo {BPM}, nhạc cụ {…}, cảm xúc {…}. Yêu cầu: không lời,
lặp liền mạch, không trống mạnh, chừa dải tần giọng nói. Đưa 3 phương án khác nhau.
```

---

