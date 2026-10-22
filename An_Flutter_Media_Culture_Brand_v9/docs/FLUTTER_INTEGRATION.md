# Cài vào ứng dụng Flutter hiện có

**1.** Copy nguyên thư mục `packages/an_nhien_eastern_content` vào `<repo>/packages/`.

**2.** Trong `apps/mobile/pubspec.yaml` (sửa `path:` tương ứng cấu trúc repo):

```yaml
dependencies:
  an_nhien_eastern_content:
    path: ../../packages/an_nhien_eastern_content
```

**3.** Chạy `flutter pub get` (trong app). Sử dụng:

```dart
import 'package:an_nhien_eastern_content/an_nhien_eastern_content.dart';

final repository = EasternContentRepository();
final index = await repository.getSystemIndex();
final bdj = await repository.getDraftCatalog('baduanjin');
final metadata = await repository.getSystem('baduanjin');

// Dev-only previews; draft MUST NOT be exposed as workouts in production.
final combined = await repository.mergeForDeveloperPreview(existingV1Catalog);

// Use poster image with Image.asset:
final imagePath = repository.imageKey('assets/series/E101/01_title.webp');
// Image.asset(imagePath)
```

**4.** Với UI production, chỉ dùng `EasternContentRepository.visiblePublishedRoutines(catalog)` hoặc publish gate đã có trong app. Gói này là **draft only**, nên danh sách bài mới được phép tập sẽ rỗng cho đến khi phê duyệt.

**5.** Catalog v1-compatible nằm tại `assets/catalog/<slug>.draft.v1.json`; metadata `PracticeSystem` là sidecar `assets/catalog/<slug>.system.v1.json`. Không chèn `PracticeSystem` vào JSON catalog v1 (schema additionalProperties=false). Sau này mở schema v2 hoặc CMS adapter để mô hình hóa chính thức.

**6.** Khi thay ảnh bìa demo bằng video/hình tư thế, cập nhật đúng SHA-256, bytes, media IDs, review records. Không tự đổi status thành approved nếu chưa có bằng chứng đánh giá.

**7.** Tests: `flutter test` trong package/app; validator Python: `python scripts/validate_content.py` ở thư mục gói. Những tests chưa chạy trên Flutter SDK trong môi trường tạo artifact phải được chạy trên máy phát triển.

**Lưu ý:** Package này không cài CMS, backend hoặc sync; là content extension có cấu trúc mở cho tương lai.
