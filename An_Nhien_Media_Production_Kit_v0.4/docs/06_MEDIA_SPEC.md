# 06 — Media production contract

**Ngày:** 18/10/2026  
**Nguồn:** Production brief 06 do chủ sản phẩm cung cấp.  
**Đối tượng:** AI media agents, studio quay, reviewer và Flutter engineering.

## Yêu cầu chất lượng

- Chỉ sử dụng media diễn tả tư thế đúng, **không dùng ảnh minh họa trang trí làm hướng dẫn vận động**.
- Người hướng dẫn 50–65 tuổi, toàn thân trọn khung, chừa 6–8% lề, một người xuyên suốt mỗi series, trang phục trơn tương phản nền; bối cảnh kem sáng, xanh teal đậm `#073F3B` / `#0A5249`, nhấn bạc hà `#7FD1BC`.
- Không chữ, watermark hoặc logo trong khung tư thế; app hiển thị lời chú thích và nút điều khiển.
- Các hệ khí công phải chốt **trường phái, nguồn bài, trình tự, kỹ thuật, giọng đọc và người duyệt** ở T14 trước khi sản xuất / publish.
- Không nín thở, ép hơi, gồng, bẻ/giật cổ, ấn vùng cổ trước. Chỉnh tư thế theo năng lực và dừng nếu khó chịu. Các biến thể ghế được đánh dấu ở `catalog/media_requirements.v1.json`, reviewer xác nhận.

## File formats

| Asset | Format | Contract |
|---|---|---|
| Pose | WebP q85 hoặc PNG | 1080×1080, WebP khuyến nghị ≤150KB, toàn thân |
| Routine cover | WebP | 1080×1440 (3:4), thumbnail 540×720 |
| Video | MP4 H.264/AAC | 1920×1080, 16:9, 30fps, bitrate ≤8Mbps, AAC 48kHz, tiếng Việt ghép sẵn |
| Subtitles | WebVTT | vi-VN, UTF-8, khớp timecode video final, ≤2×32 ký tự mỗi caption |
| Optional voice | M4A/AAC | 48kHz mono, −16 LUFS, chỉ khi voice tách track |
| UI cue | OGG + M4A | 48kHz, −18 LUFS, ≤1.0s, trừ cue hoàn tất ≤1.5s |

## Path conventions

- Basic frames: `assets/series/E0x/frames/NN.png` (E03 có 6 khung, các mã khác 4).
- Basic video+captions: `assets/media/E0x/guide.mp4`, `assets/media/E0x/guide.vi.vtt`.
- Eastern assets: `packages/an_nhien_eastern_content/assets/series/E101/pose_start.webp`, `pose_transition.webp`, `pose_end.webp`, `guide.mp4`, `guide.vi.vtt`.
- Chair/support variant `_chair` ở 3 pose nếu được duyệt; **12 mã đề xuất**, chưa chốt T14.
- UI cues: `assets/audio/cues/<cue-name>.ogg` và `.m4a`.

## Release gates

- Chỉ nội dung đạt duyệt mới cập nhật paths + SHA-256 + bytes vào manifest và `an8-east/media_plans/<system>/<exerciseId>/series.plan.v1.json`.
- Media file phải có creator, tool, AI disclosure, bản quyền thương mại, `contentSafetyReviewer`, ngày duyệt.
- `python scripts/validate_media.py --mode release` phải pass **và** có manual QA; script không đánh giá được đúng tư thế hay âm thanh diễn đạt tự nhiên.
- Các ảnh AI đã tạo ở pack v0.3 phải tiếp tục để `demoOnly` / `draft` cho đến khi thay bằng media người thật được duyệt.

## Các vấn đề P0 từ brief

- **E04/03:** tư thế tay cũ giơ quá đầu trong khi hướng dẫn yêu cầu ngang vai hoặc thấp hơn; quay/sinh lại **đúng** tư thế trước khi dùng.
- **E06/01–04:** ảnh cũ không có ghế/chỗ vịn, đầu gối cao; quay lại nhấc chân thấp, có điểm tựa trong khuôn hình.
- **Lục Tự Quyết:** cần 6 file phát âm chuẩn do chuyên gia chỉ định. Không gắn giọng TTS chưa thẩm định làm “final”.
- **Tẩy Tủy Kinh:** không sản xuất tư thế cho đến khi hoàn tất xác minh nguồn T17.
