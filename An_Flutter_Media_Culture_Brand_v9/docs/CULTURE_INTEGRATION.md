# An — Lịch sử, văn hóa & ý nghĩa từng động tác

Gói `packages/an_nhien_cultural_content` chứa **67 bài viết**, **7 hồ sơ hệ**, **6 chuyện kể**, kịch bản thuyết minh bằng tiếng Việt và nguồn tham khảo.

Gắn tại **Exercise Detail → Tìm hiểu**: Ý nghĩa tên gọi, bối cảnh, hình tượng văn hóa, quan sát chuyển động, nguồn. Gắn tại Practice System → Lịch sử/Văn hóa. Các chuyên đề người kể chuyện hiển thị như bài viết tới khi có audio thật, không hiển thị nút Play khả dụng.

Dữ liệu `editorial_draft`: có thể thử nghiệm trong dev; chưa phải nội dung lịch sử đã thẩm định. Huyền thoại Bồ Đề Đạt Ma phải được giới thiệu là truyền thuyết, ý nghĩa tạng phủ/khí chỉ là diễn giải văn hóa, không chứng minh điều trị. Không tự phát nội dung giải thích trong lúc người dùng tập.

Lưu ý: tên package kỹ thuật vẫn là `an_nhien_cultural_content` để giữ import/đường dẫn; **text hiển thị là An**.

```yaml
dependencies:
  an_nhien_cultural_content:
    path: ../../packages/an_nhien_cultural_content
  an_brand:
    path: ../../packages/an_brand
```

```dart
import 'package:an_nhien_cultural_content/an_nhien_cultural_content.dart';
import 'package:an_brand/an_brand.dart';

final story = await CulturalContentRepository().getStoryByExerciseId('E101');
// story: meaning, movementAwareness, culturalAngle, narratorScript etc.
// AnLockup() trong app bar; các nội dung Tìm hiểu không tự play.
```
