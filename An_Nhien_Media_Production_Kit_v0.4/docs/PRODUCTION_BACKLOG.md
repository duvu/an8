# T14/T06/T16 — Media Production Backlog

## Blocking dependencies

- **T14:** Chuyên gia chọn hệ/trường phái, tư thế/nhịp/cách phát âm cho 60 thức trước khi quay/điền media plan.
- **T06:** Flutter player cần video/audio adapter, inter-step cues và handling on background/interruption.
- **T16:** Publish gate kết hợp approval, bản quyền, manifest checksums, xác minh trên thiết bị thật.

## P0

- [ ] E04/03: Làm lại ảnh dưới/ngang vai, duyệt tư thế; hiện ảnh cũ quá đầu, không đạt.
- [ ] E06/01–04: Làm lại có điểm vịn/ghế, gối nâng thấp, không mất thăng bằng.
- [ ] Duyệt 3 icon app (đã có PNG source; cần brand approval).
- [ ] Nghe duyệt 4 âm báo (đã có OGG/M4A).
- [ ] T14: xác định 12 mã thực sự cần bản `_chair` (danh sách trong catalog).
- [ ] Sản xuất chuỗi ảnh và voice/video thực theo từng hệ, KHÔNG dùng hình AI minh họa chưa duyệt làm hướng dẫn.
- [ ] Đánh dấu tất cả nội dung cũ `draft` / `intro-only` khi chưa đủ bằng chứng.

## P1

- [ ] Quay video voice final cho E01–E07, mix tiếng đọc cùng video, làm phụ đề khớp timecode.
- [ ] Sản xuất 3 pose và video cho 60 thức sau T14; QC kỹ thuật, camera, license.
- [ ] Phát âm 6 âm Lục Tự Quyết bởi người được chuyên gia chỉ định.

## P2

- [ ] 5 bìa routine riêng 3:4.
- [ ] Kiểm định ngoài trời từ 2 m, ánh sáng thấp, accessibility và audio.

## Release gates

Không publish nếu chưa đủ clip, pose, phụ đề khớp video, reviewer, giấy phép và kiểm tra trên thiết bị. Script `validate_media.py` chỉ kiểm được kỹ thuật và metadata, **không chứng minh đúng tư thế**.
