# An Nhiên — Eastern Content Drop-in v0.1.0 (DRAFT)

**Tải và giải nén vào root workspace Flutter** rồi đọc `docs/FLUTTER_INTEGRATION.md`.

## Nội dung

- 6 `PracticeSystem` entries: Bát Đoạn Cẩm, Dịch Cân Kinh, Ngũ Cầm Hí, Lục Tự Quyết, Thái Cực 24 thức, Tẩy Tủy Kinh (concept-only).
- 5 catalog JSON v1-compatible, **60 Exercise drafts**, 5 Routine drafts, 60 MediaAsset cards; stable IDs bắt đầu E101..E524 / R101..R105 (không trùng bộ E01–E07 / R01–R05).
- Một cover riêng cho mỗi hệ, một thẻ ảnh cho mỗi thức và một frame `chưa duyệt` để giữ scaffold media series; `media_plans` dành cho kỹ thuật/quay video sau này.
- Source references trong system metadata; kế hoạch kiểm duyệt và backlog.
- Flutter package pure assets + Dart loader, preview HTML và Python validator.

**Không chứa hướng dẫn tập chính thức, video, chuyển động chính xác hoặc nội dung được duyệt.** Không dùng ảnh decorative cover để dạy tư thế. Tẩy Tủy Kinh không có chuỗi giả định.

## Copy nhanh

```bash
cp -r packages/an_nhien_eastern_content <YOUR_WORKSPACE>/packages/
# apps/mobile/pubspec.yaml:
# an_nhien_eastern_content:
#   path: ../../packages/an_nhien_eastern_content
cd <YOUR_WORKSPACE>/apps/mobile && flutter pub get
```

## Tests

```bash
python scripts/validate_content.py
# flutter test packages/an_nhien_eastern_content/test  # từ root app khi có Flutter SDK
```

Bổ sung catalog thành production chỉ sau khi nguồn, dịch tên, kỹ thuật, hình/video/audio, accessibility và quyền sử dụng được kiểm duyệt. Không xây CMS hoặc backend trong gói này.
