# An Nhiên — Content Catalog & Exercise Series

**Version 1.1 · Flutter MVP · 18/10/2026**

## Quyết định

**Không xây CMS / Admin portal / Content API trong MVP.** Thay vào đó, nội dung phải là dữ liệu độc lập với UI và được quản lý như một catalog theo phiên bản trong Git. App Flutter truy cập nội dung qua `ContentCatalogRepository`, không hardcode động tác trong Widget, không phụ thuộc JSON asset path cố định trong presentation layer. Khi có CMS trong tương lai, thay lớp cung cấp catalog bằng remote adapter mà không cần viết lại model, routine composition, player, progress hay UI.

- **MVP:** bundled manifest trong `catalog/catalog.draft.v1.json` + media trong `assets/series/`, import vào Drift/SQLite nếu cần. Thay đổi Git-manifest trong MVP vẫn cần phát hành bản app/pack mới; **không hứa** bài mới tự xuất hiện từ xa khi chưa có remote sync.
- **MVP extension point:** interface `ContentCatalogRepository { getCatalog(); getRoutine(id, version); getExercise(id, version); ... }` với `BundledCatalogDataSource`; định nghĩa `CatalogSource` và capability `supportsRemoteRefresh=false`. Có thể thêm `RemoteCatalogDataSource` / CDN manifest sau mà không làm lại domain.
- **V2 (không implement bây giờ):** CMS, upload media, người kiểm duyệt, catalog publish pipeline, remote sync có chữ ký/checksum, remote kill switch có giới hạn offline, analytics bằng sự đồng ý.

## Domain

| Entity | Vai trò | Quy tắc |
|---|---|---|
| `Exercise` | Động tác cơ bản tái sử dụng | ID ổn định + version; mô tả, hướng dẫn từng tư thế, safety notes, media |
| `Routine` | Chuỗi động tác | Không chứa bản sao Exercise; tham chiếu `(exerciseId, exerciseVersion)` |
| `RoutineStep` | Một lần dùng động tác trong bài | `order`, `durationSeconds`, `exerciseVersion`, media variant |
| `MediaAsset` | Ảnh series, các frame, về sau video/Rive/audio | Đường dẫn độc lập với Flutter widget, checksum SHA-256, dung lượng, license, review status |
| `WorkoutSession` | Một lượt tập | Ghi `(routineId, routineVersion)` và snapshot tham chiếu nội dung để giữ lịch sử chính xác |

**Trạng thái nội dung:** `draft → in_review → approved → retired`. Một catalog `published` chỉ được tham chiếu Exercise/Media/Routine đã `approved`, không `demoOnly`; quyết định publish phải là thao tác có kiểm duyệt riêng biệt. Việc chỉ đổi JSON `reviewStatus=approved` **không** có nghĩa nội dung đã qua kiểm duyệt. Cần bằng chứng, vai trò chuyên gia, ngày, checklist và nguồn cấp phép.

## Asset series độc lập

Mỗi `E01–E07` nằm trong thư mục riêng:

```text
assets/
  source/generated_master_contact_sheet.png  # chỉ là nguồn tạo minh họa, không đưa vào app release
  series/
    E01/
      storyboard.png     # thẻ dọc 1080x1440 có 4 bước, theme xanh đậm
      thumbnail.png      # thẻ nhỏ 540x720
      series_strip.png   # phiên bản ngang tham khảo
      frames/
        01.png ... 04.png  # khung tư thế riêng, chỉ là visual reference
    E02/ ... E07/
  R02_sequence_overview.png
catalog/
  catalog.draft.v1.json
  catalog.schema.v1.json
scripts/
  validate_catalog.py
  generate_catalog.py
  build_series_assets.py
```

Từng khung hình tách rời để sau này Flutter có thể hiển thị carousel theo bước, storyboard, hỗ trợ voice cue, hoặc thay thế bằng animation/video mà không ảnh hưởng schema. **Đây là ảnh tĩnh, không phải Lottie/Rive/video hay hướng dẫn chuyển động đã kiểm chứng.** Không phát loop ảnh như một bài tập đã duyệt chỉ để vượt qua release gate. Một số pose tạo bởi AI có thể không chính xác về biên độ/cơ sinh học và chữ gốc trên ảnh có thể không nhất quán; lời hướng dẫn chính thức lấy từ domain data đã review, không trích text từ ảnh AI.

| Exercise | Thời lượng trong R02 | Frame | Lưu ý |
|---|---:|---:|---|
| E01 Thở tự nhiên | 2 phút | 4 | Không ép nhịp 4–6 hay nín thở |
| E02 Xoay vai nhẹ | 2 phút | 4 | Không xoay mạnh cổ |
| E03 Bàn tay & cổ chân | 2 phút | 6 | Không kéo đến mức tê tăng |
| E04 Nâng hạ hai tay | 2 phút | 4 | Chỉ nâng tới mức thoải mái; AI có frame đưa tay quá đầu, cần sửa/duyệt |
| E05 Chuyển trọng tâm | 2 phút | 4 | Hai chân chạm sàn, có ghế/chỗ vịn |
| E06 Đi bộ tại chỗ | 3 phút | 4 | Gối nâng thấp; AI có frame nâng cao, cần sửa/duyệt |
| E07 Ngồi thư giãn | 1 phút | 4 | Thở tự nhiên, không gò ép |
| **Tổng** | **14 phút** | **30** | Chưa duyệt để hướng dẫn công khai |

## Cách thêm động tác sau này

1. Tạo ID mới, ví dụ `E08`, version 1; tạo `assets/series/E08/` gồm thumbnail/storyboard/frames và media bản quyền hợp lệ.
2. Thêm `Exercise` vào catalog, khai báo `MediaAsset` và SHA-256; ghi reviewStatus `draft`, demoOnly `true` cho đến khi duyệt.
3. Thêm `RoutineStep` vào routine mới hoặc tạo phiên bản routine mới, **không sửa âm thầm version đã có**.
4. Chạy `python scripts/validate_catalog.py` để kiểm tra schema, checksum, tham chiếu, duration và publish gate.
5. Sau kiểm duyệt vận động/media/voice phụ đề, chốt pack, tạo bản phát hành có version; về sau CMS sẽ thực hiện những bước tương đương.

## Contract Flutter để mở đường CMS

```dart
abstract interface class ContentCatalogRepository {
  Future<ContentCatalog> getCatalog({bool forceRefresh = false});
  Future<Exercise?> getExercise(String id, int version);
  Future<Routine?> getRoutine(String id, int version);
  Stream<ContentCatalog> watchCatalog();
}

abstract interface class CatalogDataSource {
  Future<CatalogManifest> readManifest();
}
```

MVP: `BundledCatalogDataSource` → validator/parser → immutable domain objects → repository → Riverpod → UI. `forceRefresh` trong MVP có thể chỉ reload source cục bộ, **không thực hiện network request**. Khi thêm RemoteAdapter, thực hiện optimistic download → hash/signature validate → atomic swap → pin phiên đang tập vào version cũ. CMS chỉ quản trị và xuất bản dữ liệu; không thuộc domain/mobile player.

## Chuẩn an toàn, licensing và phát hành

Tất cả ảnh trong gói này được tạo bằng AI cho mục đích minh họa thiết kế, gắn watermark *HÌNH MINH HỌA AI • CHƯA KIỂM DUYỆT*. Chúng có thể dùng trong prototype/dev preview với nhãn demo; **không** chứng minh độ chính xác của tư thế, không thay thế video người thật được hướng dẫn và chuyên gia kiểm duyệt. Khi sản xuất: quay video thật, kiểm tra biên độ/tư thế, đánh giá nguy cơ ngã, bổ sung lựa chọn ngồi/chỗ vịn, đảm bảo lời dẫn và phụ đề khớp, kiểm tra quyền phát hành thương mại và thay asset từ `draft` sang approved sau quy trình chính thức.

Nếu user gặp đau ngực, khó thở, choáng, yếu hoặc tê mới/tăng rõ: yêu cầu dừng; không hướng dẫn tác động sâu vào cổ trước/vùng xoang cảnh.
