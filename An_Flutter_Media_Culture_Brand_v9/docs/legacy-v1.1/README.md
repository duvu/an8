# AN NHIÊN — Flutter MVP · Package v1.1

**Ngày cập nhật:** 18/10/2026  
**Mục tiêu:** PRD, prompt Claude Code, wireframe tương tác, catalog CMS-ready và 7 series ảnh độc lập.

## Danh sách tài liệu

1. `01_PRD_An_Nhien_Flutter.md` — yêu cầu sản phẩm, kiến trúc Flutter, offline/media/player, safety và catalog CMS-ready.
2. `02_Claude_Code_Flutter_Prompt.md` — prompt triển khai Flutter, dùng catalog data-driven.
3. `03_Wireframe_Spec.md` — sitemap/luồng/screens và trải nghiệm series.
4. `04_Wireframe_Interactive.html` — prototype bấm thử 12 màn hình, hiển thị ảnh series tương ứng; **mở HTML trong thư mục package**, không di chuyển HTML tách khỏi `assets/`.
5. `05_Content_Catalog_And_Series.md` — kiến trúc mở cho CMS sau MVP, cách thêm động tác, quy định version/schema/publish/review.
6. `assets/series/E01..E07/` — mỗi exercise một series: `storyboard.png`, `thumbnail.png`, `series_strip.png`, `frames/*.png`; tổng **30 frame**.
7. `assets/R02_sequence_overview.png` — toàn bộ chuỗi R02 14 phút (hình tổng quan draft).
8. `assets/source/` — master AI collage để tái dựng asset, **chỉ dùng phát triển**, không đóng vào release app.
9. `catalog/catalog.draft.v1.json` và `catalog/catalog.schema.v1.json` — manifest mẫu có media checksums, tham chiếu exercise/routine có version, validation gate.
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

Đọc PRD, content spec rồi cung cấp prompt Claude Code tại project root. Flutter **không hardcode** bài tập: dùng `ContentCatalogRepository` đọc `catalog/catalog.draft.v1.json`, UI render từ `Routine → RoutineStep → Exercise → MediaAsset`. Dữ liệu hiện là demo draft, không dùng để thực hành khi chưa duyệt.

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

**Trạng thái:** Không có source code Flutter, không có CMS, backend, Rive/video/voice thực. Ảnh được tạo bằng AI là tài liệu minh họa thiết kế có watermark **CHƯA KIỂM DUYỆT**; có thể không chính xác hoàn toàn về biên độ/tư thế, nhất là E04/E06. Chỉ phát hành nội dung vận động sau khi được người có chuyên môn phù hợp đánh giá và cấp phép media hợp lệ.
