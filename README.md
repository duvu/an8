# AN NHIÊN — Flutter MVP · Package v1.1

**Ngày cập nhật:** 18/10/2026  
**Mục tiêu:** PRD, prompt Claude Code, wireframe tương tác, catalog CMS-ready và 7 series ảnh độc lập.

## Danh sách tài liệu

1. `01_PRD_An_Nhien_Flutter.md` — yêu cầu sản phẩm, kiến trúc Flutter, offline/media/player, safety và catalog CMS-ready.
2. `02_Claude_Code_Flutter_Prompt.md` — prompt triển khai Flutter, dùng catalog data-driven.
3. `03_Wireframe_Spec.md` — sitemap/luồng/screens và trải nghiệm series.
4. `04_Wireframe_Interactive.html` — prototype bấm thử 12 màn hình, hiển thị ảnh series tương ứng; **mở HTML trong thư mục package**, không di chuyển HTML tách khỏi `assets/`.
5. `05_Content_Catalog_And_Series.md` — kiến trúc mở cho CMS sau MVP, cách thêm động tác, quy định version/schema/publish/review.
5b. `06_Media_Production_Brief.md` — prompt và danh sách media cần sản xuất bổ sung (icon, âm báo, khung tư thế, video, phụ đề).
5c. `07_ChatGPT_Media_Prompts.md` — prompt ChatGPT tạo ảnh chi tiết từng thức, kịch bản giọng đọc, âm báo, nhạc nền.
5d. `08_ChatGPT_Completion_Prompt.md` — kiểm kê media còn thiếu và prompt yêu cầu ChatGPT hoàn thiện.
5e. `09_Suno_Music_Prompts.md` — prompt Suno cho 6 bản nhạc nền và cách hậu kỳ.
6. `assets/series/E01..E07/` — mỗi exercise một series: `storyboard.png`, `thumbnail.png`, `series_strip.png`, `frames/*.png`; tổng **30 frame**.
7. `assets/R02_sequence_overview.png` — toàn bộ chuỗi R02 14 phút (hình tổng quan draft).
8. `assets/source/` — master AI collage để tái dựng asset, **chỉ dùng phát triển**, không đóng vào release app.
9. `catalog/catalog.v1.json` và `catalog/catalog.schema.v1.json` — manifest mẫu có media checksums, tham chiếu exercise/routine có version, validation gate.
10. `scripts/` — lệnh tái tạo frame/storyboard, catalog và kiểm tra.

## Bảy series

| ID | Tên | Thời lượng trong R02 | Frames |
|---|---|---:|---:|
| E01 | Thở tự nhiên | 2 phút | 4 |
| E02 | Xoay vai nhẹ | 2 phút | 4 |
| E03 | Bàn tay và cổ chân | 2 phút | 6 |
| E04 | Nâng hạ hai tay | 2 phút | 4 |
| E05 | Chuyển trọng tâm | 2 phút | 4 |
| E06 | Đi bộ tại chỗ | 3 phút | 4 |
| E07 | Ngồi thư giãn | 1 phút | 4 |
| | **Tổng** | **14 phút** | **30** |

## Dùng trong Flutter

Đọc PRD, content spec rồi cung cấp prompt Claude Code tại project root. Flutter **không hardcode** bài tập: dùng `ContentCatalogRepository` đọc `catalog/catalog.v1.json`, UI render từ `Routine → RoutineStep → Exercise → MediaAsset`. Dữ liệu hiện là demo draft, không dùng để thực hành khi chưa duyệt.

## Kiểm tra và mở prototype

```sh
python -m pip install jsonschema pillow
python scripts/validate_catalog.py
# Mở 04_Wireframe_Interactive.html trong browser tại thư mục này.
```

Nếu có cập nhật asset, chạy:

```sh
python scripts/build_series_assets.py
python scripts/generate_catalog.py
python scripts/validate_catalog.py
```

**Trạng thái:** Đã có app Flutter MVP (xem phần dưới và `TRACKER.md`); chưa có CMS, backend, Rive/video/voice thực. Ảnh series được tạo bằng AI và đã được chủ sản phẩm duyệt làm nội dung chính thức (xem `DECISIONS.md` D08); **chưa** có kiểm duyệt chuyên môn hay rà soát bản quyền, và có thể không chính xác hoàn toàn về biên độ/tư thế, nhất là E04/E06.

## App Flutter

Yêu cầu: Flutter 3.47.x stable (pin trong `pubspec.yaml`). Quy tắc cho agent: `AGENTS.md`; tiến độ: `TRACKER.md`; quyết định: `DECISIONS.md`.

```sh
flutter pub get
flutter run
dart format --set-exit-if-changed lib test
flutter analyze
flutter test                         # unit + widget + accessibility
flutter build apk --release
```

Release chỉ hiện nội dung `approved`; nội dung `draft` thêm sau này chỉ hiện ở debug hoặc khi build với `--dart-define=AN_NHIEN_PREVIEW_CONTENT=true`, luôn kèm nhãn DEMO (D06).

Cấu trúc: `lib/app` (router, theme 3 lớp token, l10n tiếng Việt), `lib/core` (clock, UI dùng chung, adapter nền tảng), `lib/features/<feature>/{domain,data,application,presentation}`, `lib/data/local` (SQLite + migrations).

Nội dung dưỡng sinh phương Đông: gói `packages/an_nhien_eastern_content` (bản gốc trong `An_Nhien_Eastern_Content_DropIn_v0.1/`), hiện dạng giới thiệu, chưa tập được (`DECISIONS.md` D09).

Icon app: sửa `assets/branding/` rồi chạy `python scripts/build_app_icons.py`. Âm báo: `assets/audio/cues/`.

Thêm động tác mới: làm theo `05_Content_Catalog_And_Series.md`, sau đó thêm `assets/series/E0x/frames/` và `thumbnail.png` vào `pubspec.yaml`; chạy `scripts/validate_catalog.py` và `flutter test`. Không cần sửa UI.
