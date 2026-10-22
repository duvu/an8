# 08 — Còn thiếu gì & prompt yêu cầu ChatGPT hoàn thiện media

**Ngày:** 18/10/2026 · **Dựa trên:** kiểm kê `An_Nhien_Media_Production_Kit_v0.4/media_manifest.csv` (402 mục) và `An_Nhien_Media_07_Production_Jobs_v0.5/media_production_tracker.csv` (392 mục). Hai script kiểm tra đi kèm đều báo **chưa sẵn sàng phát hành**.

---

## 1. Hiện trạng

### 1.1 Đã có và đã đưa vào app

| Media | File | Trong app | Còn phải làm |
|---|---|---|---|
| Icon ứng dụng | `assets/branding/` (master 1024, foreground/background Android, SVG) | Đã sinh icon Android (5 mật độ + adaptive) và iOS (19 kích thước) bằng `scripts/build_app_icons.py`; hiện trên launcher | Duyệt thương hiệu |
| 4 âm báo | `assets/audio/cues/cue_{countdown,step_start,step_soon,complete}.m4a` | Player phát khi đếm 3-2-1, bắt đầu động tác, còn 10 giây và hoàn thành. Bật/tắt bằng "Âm báo khi tập" trong Cài đặt | Nghe duyệt. **`cue_countdown` to hơn 3 âm còn lại khoảng 6 dB** (đỉnh −3.9 dB so với −10 dB) |

### 1.2 Đã có nhưng chỉ là bản nháp (chưa đưa vào app)

- 67 kịch bản giọng đọc có mốc thời gian (`production_jobs/voice_scripts/`) và 67 phụ đề VTT nháp (`production_jobs/subtitle_drafts/`).
- 246 job prompt ảnh (`production_jobs/image_prompts/`) và 6 mô tả nhạc nền (`production_jobs/music/`).
- 2 ảnh collage tham khảo phong cách, ghi rõ **NOT_FOR_APP**.

### 1.3 Còn thiếu

| # | Nhóm | Số lượng | Đường dẫn đích | ChatGPT làm được? |
|---|---|---:|---|---|
| M1 | Khung tư thế E01–E07 (làm lại; sửa E04-03, E06) | 30 | `assets/series/E0x/frames/NN.png` | Có: tạo ảnh |
| M2 | Khung tư thế 60 thức phương Đông | 180 | `packages/an_nhien_eastern_content/assets/series/E1xx…E5xx/pose_{start,transition,end}.webp` | Có: tạo ảnh. **Bắt buộc chuyên gia duyệt** |
| M3 | Bản vịn ghế/ngồi (12 thức × 3) | 36 | `…/pose_*_chair.webp` | Có: tạo ảnh |
| M4 | Bìa routine R01–R05 | 5 | `assets/covers/R0x_cover.webp` | Có: tạo ảnh |
| M5 | Giọng đọc 67 động tác | 67 | `<MÃ>_voice.m4a` cạnh ảnh của động tác (hoặc ghép trong video) | Một phần: chỉnh kịch bản. File âm thanh cần công cụ TTS hoặc người đọc nếu ChatGPT không xuất được |
| M6 | Phụ đề khớp giọng đọc | 67 (7 nháp + 60 mới) | `<MÃ>.vi.vtt` cạnh ảnh của động tác | Có: viết VTT; chốt lại sau khi có file giọng thật |
| M7 | Video hướng dẫn 1920×1080 có giọng | 67 | `<MÃ>.mp4` cạnh ảnh của động tác | Không nên dùng video AI cho kỹ thuật phương Đông. ChatGPT viết shot list; cần quay người thật |
| M8 | Nhạc nền M1–M6 | 6 | `assets/audio/music/music_*.m4a` | Một phần: viết prompt nhạc; cần công cụ tạo nhạc hoặc thư viện có giấy phép |
| M9 | Phát âm Lục Tự Quyết | 6 | `…/E40x/E40x_pronunciation.m4a` | **Không**: cần người phát âm do chuyên gia chỉ định |

**Ngoài media còn thiếu:**

- Chuyên gia chốt trường phái, tên thức và kỹ thuật (T14) trước khi tạo ảnh hay quay phần phương Đông.
- Người duyệt và ngày duyệt cho từng file; xác nhận giấy phép.
- Phía app:
  - phát video, giọng đọc, nhạc nền (phần còn lại của T06);
  - đưa thức phương Đông vào catalog chính để tập được (T16).

---

## 2. Prompt 08 (dán vào ChatGPT)

**Chuẩn bị đính kèm:**

1. `07_ChatGPT_Media_Prompts.md` (mô tả tư thế và kịch bản gốc).
2. Thư mục `An_Nhien_Media_07_Production_Jobs_v0.5/production_jobs/` (nén ZIP).
3. Ảnh nhân vật đã chốt: nam áo teal cho E01–E07, nữ áo kem cho phương Đông. Nếu chưa có, dùng `assets/series/E01/frames/01.png` và tạo nhân vật nữ theo mục 2.2 của file 07.
4. Ảnh `assets/series/E04/frames/03.png` (minh họa lỗi cần sửa).

```text
Bạn là đội sản xuất media cho "An Nhiên", ứng dụng dưỡng sinh tiếng Việt cho người
trung niên và lớn tuổi. Tôi đính kèm: (1) file 07 gồm mô tả tư thế, kịch bản giọng đọc,
âm báo, nhạc nền; (2) thư mục production_jobs (246 job ảnh .txt, 67 kịch bản giọng JSON,
67 phụ đề nháp, 6 mô tả nhạc); (3) ảnh nhân vật tham chiếu; (4) ảnh E04-03 bị sai.

MỤC TIÊU: hoàn thiện các media còn thiếu theo danh sách M1–M9 bên dưới, đúng tên file,
kích thước và định dạng, để tôi chép thẳng vào dự án.

NGUYÊN TẮC BẮT BUỘC
1. Không đánh dấu bất kỳ file nào là "đã duyệt". Mọi file đều là bản đề xuất chờ người
   duyệt. Không tự bịa kỹ thuật: chỉ minh họa đúng mô tả trong job; nếu mô tả mơ hồ,
   liệt kê câu hỏi cho tôi thay vì đoán.
2. Ảnh tư thế: vuông 1024×1024, toàn thân trọn khung (lề 6–8%), photorealistic, nền kem
   #FAF9F3, ánh sáng mềm, KHÔNG chữ/số/logo/watermark, 5 ngón mỗi tay, khớp đúng hướng,
   biên độ nhẹ an toàn cho người lớn tuổi. Cùng một nhân vật, trang phục, bối cảnh, góc máy
   trong cùng một thức; chỉ tư thế thay đổi.
3. Làm theo lô: mỗi lần trả lời xử lý MỘT động tác (3 khung, kèm 3 khung _chair nếu job có).
   Sau mỗi ảnh, tự kiểm tra theo checklist (mục KIỂM TRA) và tạo lại nếu sai. Cuối mỗi lô,
   in bảng kết quả.
4. Tên file đúng tuyệt đối như cột "Tên file" (không thêm hậu tố, không đổi hoa thường).

DANH SÁCH VIỆC
M1. E01–E07: làm lại 30 khung theo job E01…E07. Sửa bắt buộc: E04 khung 03 tay chỉ
    ngang vai (không quá đầu); E06 có lưng ghế cạnh người, gối nhấc thấp, tay vịn ghế.
    Tên file: E0x_NN.png (ví dụ E04_03.png).
M2. 60 thức phương Đông: 180 khung theo job E101…E524.
    Tên file: E1xx_pose_start.webp, E1xx_pose_transition.webp, E1xx_pose_end.webp.
M3. 12 thức có bản vịn ghế (E102, E105, E106, E108, E210, E309, E310, E503, E513, E515,
    E516, E517): 36 khung. Tên file: E1xx_pose_start_chair.webp, …
M4. 5 ảnh bìa routine 3:4 (1080×1440), CÓ THỂ có tiêu đề tiếng Việt lớn, rõ:
    R01 "Khởi động nhẹ – 6 phút", R02 "Dưỡng sinh sáng – 14 phút",
    R03 "Thư giãn cổ vai – 8 phút", R04 "Dưỡng sinh trên ghế – 10 phút",
    R05 "Thư giãn buổi tối – 6 phút". Dùng nhân vật nam áo teal, bảng màu teal/kem.
    Tên file: R0x_cover.webp.
M5. Giọng đọc: với từng file voice_scripts/*.json, viết lại thành văn bản đọc cho TTS
    (giữ mốc thời gian, câu ngắn, ấm, không hứa hẹn sức khỏe). Nếu bạn xuất được file
    âm thanh: giọng tiếng Việt chuẩn, ấm, chậm 110–130 từ/phút, M4A mono 48 kHz, −16 LUFS,
    tên E0x_voice.m4a / E1xx_voice.m4a; nếu không, xuất file .txt cùng tên để tôi đưa
    vào công cụ TTS.
M6. Phụ đề: xuất WebVTT tiếng Việt cho 67 động tác, mốc thời gian theo kịch bản
    (≤ 2 dòng × 32 ký tự mỗi cue). Tên file: E0x.vi.vtt / E1xx.vi.vtt.
M7. Video: KHÔNG tạo video AI cho các thức phương Đông. Với mỗi động tác, viết shot list
    để quay người thật: cảnh, góc máy, thời lượng từng đoạn khớp kịch bản, lời đọc, điểm
    chú ý an toàn, phiên bản ghế. Tên file: E0x_shotlist.md / E1xx_shotlist.md.
M8. Nhạc nền: với 6 bản trong production_jobs/music, nếu bạn tạo được nhạc thì xuất
    M4A 48 kHz stereo, vòng lặp liền mạch 2–3 phút, −23 LUFS, không lời, tên
    music_morning.m4a, music_evening.m4a, music_qigong.m4a, music_five_animals.m4a,
    music_six_sounds.m4a, music_taichi.m4a; nếu không, viết 3 phương án prompt cho công
    cụ tạo nhạc mỗi bản (≤ 60 từ, tiếng Anh) kèm ghi chú phối (ducking −10 đến −12 dB khi
    có giọng đọc).
M9. Lục Tự Quyết: KHÔNG tạo file phát âm. Chỉ viết hướng dẫn ghi âm cho người phát âm
    (6 âm xū, hē, hū, sī, chuī, xī: đọc mẫu chậm 1 lần + 1 lần kèm hơi thở ra dài, nhẹ).
M10. Âm báo: cue_countdown đang to hơn 3 âm còn lại khoảng 6 dB. Nếu xử lý được âm thanh,
    xuất lại cue_countdown.m4a giảm 6 dB; nếu không, ghi chú để tôi tự chỉnh.

KIỂM TRA (tự kiểm từng ảnh trước khi đưa tôi)
- Đúng mã, đúng khung, đúng tư thế mô tả; toàn thân trọn khung.
- Không chữ/watermark (trừ bìa M4); bàn tay 5 ngón; không biên độ quá mức.
- Cùng nhân vật và bối cảnh với các khung khác của thức.
- Thức có rủi ro ngã: bản _chair thấy rõ ghế và tay vịn.

BÀN GIAO SAU MỖI LÔ
1. Các file đúng tên.
2. Bảng CSV (dán dạng text) theo đúng cột:
   path,exercise_id,slot,width,height,duration_s,creator,tool,ai_generated,license,reviewer,review_date,notes
   - creator = "ChatGPT", tool = tên model/công cụ thực tế, ai_generated = yes
   - license = điều khoản sử dụng hiện hành của công cụ (ghi nguyên văn tên điều khoản)
   - reviewer và review_date ĐỂ TRỐNG
   - notes = điểm cần người duyệt chú ý (ví dụ "kiểm tra vị trí bàn tay khung 2")
3. Danh sách câu hỏi cho chuyên gia nếu có chỗ mô tả chưa rõ.

Bắt đầu với M1, động tác E04 (sửa lỗi), rồi E06, rồi E01–E03, E05, E07. Sau đó tôi sẽ
yêu cầu từng hệ phương Đông theo thứ tự: Bát Đoạn Cẩm, Dịch Cân Kinh, Ngũ Cầm Hí,
Lục Tự Quyết, Thái Cực 24 thức.
```

### 2.1 Câu lệnh tiếp theo trong cùng cuộc trò chuyện

```text
Tiếp tục lô {MÃ}: tạo 3 khung theo job production_jobs/image_prompts/{MÃ}/*.txt
(+ 3 khung _chair nếu có), tự kiểm tra, rồi in bảng CSV và câu hỏi cho chuyên gia.
```

```text
Kiểm tra lại {MÃ}_{khung}: {mô tả lỗi, ví dụ "tay trái giơ quá vai", "thiếu ngón tay",
"nhân vật khác khung trước"}. Tạo lại đúng mô tả, giữ nguyên nhân vật và bối cảnh.
```

```text
Lô giọng đọc và phụ đề cho hệ {tên hệ}: xử lý toàn bộ voice_scripts của hệ này theo M5
và M6, xuất file đúng tên, kèm bảng CSV.
```

---

## 3. Sau khi nhận file từ ChatGPT

1. Chép file theo đường dẫn ở mục 1.3. Chuyển đổi định dạng nếu cần:
   - PNG → WebP q85 cho phương Đông;
   - 1024 → 1080 không bắt buộc.
2. Ghép các dòng CSV vào `media_production_tracker.csv`. **Người duyệt** điền `reviewer` và `review_date`; với phương Đông là chuyên gia (T14).
3. Chạy kiểm tra:
   - `python An_Nhien_Media_Production_Kit_v0.4/scripts/validate_media.py --mode inventory`
   - `python An_Nhien_Media_07_Production_Jobs_v0.5/scripts/check_release.py`
4. Cập nhật app:
   - **E01–E07:** `python scripts/build_series_assets.py && python scripts/generate_catalog.py && python scripts/validate_catalog.py`, rồi `flutter test`.
   - **Phương Đông:**
     - thay 2 bước "thẻ tên/chờ duyệt" trong catalog nháp bằng 3 bước `pose_*` với lời trên app ở file 07;
     - khai báo asset trong `pubspec.yaml` của gói;
     - bật cho tập sau khi duyệt (T16).
   - **Giọng đọc, nhạc nền, video:** cần làm tiếp phần phát media trong Player (T06): phát giọng/video theo bước, nhạc nền có ducking, công tắc "Giọng đọc" và "Nhạc nền".
