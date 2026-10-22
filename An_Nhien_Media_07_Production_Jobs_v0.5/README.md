# An Nhiên — Media Production 07 / v0.5

Gói này chuyển bản paste "07 — Prompt ChatGPT" thành **production jobs độc lập**, scripts giọng đọc theo timestamp, phụ đề nháp và tracker.

## Có thật trong package
- 246 image production prompts: 30 khung E01–E07, 180 khung phương Đông và 36 biến thể ghế.
- 67 kịch bản voice với timestamp gốc; 67 file VTT *bản thảo*, dùng để canh tiếng sau khi có final audio/video.
- 6 bản mô tả nhạc nền, 4 âm báo ứng dụng ở OGG/M4A lấy từ media kit v0.4 (cần listening QA).
- 4 icon hiện có (cần duyệt thương hiệu), ảnh collage tham khảo style chưa duyệt.
- CSV theo dõi những output thực sự còn thiếu, script gate ngăn phát hành nhầm.

## Chưa có, không được gọi là FINAL
- 246 ảnh đúng kỹ thuật chưa được sinh theo từng pose và kiểm duyệt; không lấy ảnh collage làm instruction.
- 67 video thật có voice, 67 phụ đề synchronized với video, 6 bản nhạc mastered và 6 audio phát âm chuẩn Lục Tự Quyết.
- Giọng TTS chuyên nghiệp 67 thức, rights/license và phê duyệt nội dung.

## Tích hợp
1. Copy các folders `assets`, `packages` theo đúng đường dẫn yêu cầu vào workspace tương ứng (sau khi có media final).
2. Đội media nhận từng file `.txt` trong `production_jobs/image_prompts/E...` làm một job, sử dụng character reference cố định.
3. Với hệ phương Đông, chuyên gia chốt trường phái và tư thế trước khi phát lệnh sinh ảnh/video.
4. Đội ghi âm nhận `production_jobs/voice_scripts/*.json`; TTS/voice actor phải canh cue và phát âm chuẩn.
5. Chỉ chuyển output sang đường dẫn production sau khi reviewer xác nhận, cập nhật `media_production_tracker.csv`.
6. Chạy `python scripts/check_release.py` trước khi publish. Script phải FAIL khi thiếu bất cứ file hoặc thiếu review.

Hãy đọc `SOURCE_07_CHATGPT_MEDIA_BRIEF.md` để giữ nguyên hướng dẫn biên tập được cung cấp.
