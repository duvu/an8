# v0.8 — tích hợp vào Flutter

Giải nén tại repo root (trên branch riêng). Giữ nguyên các dependency và asset paths đã có từ v0.7.

**Mới thêm:**
- `assets/audio/music/music_{morning,evening,qigong,five_animals,six_sounds,taichi}.m4a`;
- `assets/catalog/media_delivery_status.v0.8.json`;
- `media_manifest_v08.csv`;
- `scripts/verify_v08.py` và tài liệu v0.8.

Trong `apps/mobile/pubspec.yaml`, dưới `flutter.assets` thêm đường dẫn `assets/audio/music/` và `assets/catalog/` nếu chưa có. Không thêm mặc định các pack Eastern draft vào chế độ Workout.

Chạy:
```
python scripts/verify_v08.py --integrity
python scripts/verify_v08.py --release
flutter analyze
flutter test
```

`--integrity` dự kiến PASS nếu gói đúng; `--release` dự kiến BLOCKED cho đến khi có media thật/duyệt chuyên gia.
