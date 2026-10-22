# An Nhiên Media Production Kit v0.4

Đây là **gói chuẩn sản xuất và một phần media thật**, không phải 67 bài video final.

## Đã có

- `assets/icons/`: icon PNG 1024 iOS + 432 adaptive foreground/background, SVG master.
- `assets/audio/cues/`: 4 âm báo original, mỗi cái `.ogg` + `.m4a`, 48kHz mono, normalized.
- `assets/media/E01–E07/`: bản thảo phụ đề WebVTT và JSON voice script cho từng bài (CHƯA synced video thật).
- `media_manifest.csv`: liệt kê mọi slot phải sản xuất; các trường `status`, `reviewer`, `review_date`, `license`, `sha256`.
- `catalog/plan_expected_paths.json`: mẫu mapping 60 thức vào `an8-east/media_plans` — **không tự ghi đè** plan chưa duyệt.
- `scripts/validate_media.py`: kiểm tra path, dimensions, checksum, video codecs, audio sample rate và metadata publish.

## Cách copy

Tại root của app hiện hữu: copy thư mục `assets/icons` và `assets/audio/cues` đúng cấu trúc; không xóa assets khác. Cập nhật `pubspec.yaml` để đăng ký assets và thêm cue handling vào Player (T06). Không tự động bật nội dung chưa duyệt.

## Build pipeline

1. Dùng `media_manifest.csv` làm worklist theo ID và slot.
2. Media đủ điều kiện review được đặt đúng đường dẫn relative tại root repo.
3. Quay / tạo final video & ảnh theo spec, ghi lại quyền sử dụng, người tạo, người duyệt.
4. Chạy `python scripts/validate_media.py --root <repo-root> --mode inventory` (thiếu file không fail).
5. Chỉ triển khai publish sau khi `--mode release` thành công và kỹ thuật chuyên môn được duyệt.

## Important

Danh mục `chairVariantsProposed` chỉ là đề xuất 12 thức: reviewer phải chốt. Các ảnh v0.3 là phác thảo do AI tạo; không có video thực, không thể coi là final chỉ bằng việc crop/upscale. Final audio lời nói cũng chưa có, ngoại trừ cue UI đã tổng hợp.
