# An — Brand Identity v1.0

**Tên hiển thị duy nhất: An.** Không dùng "An Nhiên" trên home, app bar, launcher, splash, quảng bá, lời dẫn thương hiệu hoặc video mở/kết.

Logo chuẩn là **hoa sen xanh ba cụm lá** trích từ master v0.8, KHÔNG tự tạo mỗi màn hình một hình sen mới. Các xuất phẩm chính nằm trong `assets/branding/an/` và Flutter widget chung trong `packages/an_brand`.

## Nơi hiển thị
- Launcher Android/iOS: icon nền `#073F3B`, hoa sen xanh, tên dưới icon là `An`.
- App bar, onboarding, nội dung văn hóa: `AnLockup` / `AnLotus`; không nhân bản ảnh.
- Ảnh thẻ bài/routine: huy hiệu ở góc; ảnh tư thế **không chèn logo** để tránh che tay/chân.
- Video: bumper mở/kết dùng asset 2 giây; watermark là `AnVideoBrandOverlay` trên lớp UI player, đặt ngoài vùng cơ thể; nếu video sản xuất riêng, đội dựng dùng chung PNG watermark. Video hướng dẫn thật chưa có trong package.
- Phụ đề: không chèn logo trực tiếp lên phụ đề, bảo đảm dễ đọc.

## Quy định không phá tương thích
Stable ID `E01–E524`, `R01–R105`, tên Dart package `an_nhien_eastern_content` và `an_nhien_cultural_content` không đổi. Chúng là định danh kỹ thuật, không phải tên thương hiệu hiển thị.

## Tích hợp trong codebase thực
Chạy `python scripts/apply_an_branding.py /path/to/apps/mobile` để xem dry-run; thêm `--apply` để sửa có backup, không cần đổi application/bundle ID. Thêm dependency `an_brand` với `path: ../../packages/an_brand` và dùng widget của package trong UI.

Không có codebase Flutter của người dùng trong package gốc, nên script chỉ cập nhật các file nền tảng tại **đường dẫn app truyền vào**; UI hiện hữu cần được tích hợp trong app thực và kiểm thử thiết bị.
