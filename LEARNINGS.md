# LEARNINGS.md — Nhật ký lỗi quan trọng

Quy trình: **Detect → Root Cause → Fix → Prevent → Verify → Record.** Bài học có giá trị tổng quát → nâng thành nguyên tắc trong `PRINCIPLES.md`.

## Mẫu

```
### L-001 — <tiêu đề ngắn> (YYYY-MM-DD)
- Detect: triệu chứng, cách phát hiện
- Root cause: nguyên nhân gốc
- Fix: thay đổi đã làm (file/commit)
- Prevent: regression test / nguyên tắc (P-xx) / check tự động
- Verify: lệnh đã chạy + kết quả
```

## Mục ghi nhận

### L-001 — Validator catalog cần dependency chưa được ghi rõ cho agent (2026-10-18)
- Detect: `python3 scripts/validate_catalog.py` báo thiếu `jsonschema` trên máy dev.
- Root cause: dependency Python chỉ nêu trong README, không có trong quy trình agent.
- Fix: verify gate trong `AGENTS.md` §3 ghi rõ cần `jsonschema`, `pillow`; chạy trong venv riêng.
- Prevent: P09.
- Verify: venv + `pip install jsonschema pillow` → validator PASS (7 exercises, 5 routines, 7 media collections).

### L-002 — Palette wireframe không đạt contrast WCAG AA (2026-10-18)
- Detect: khi token hóa (T02), tính contrast palette của `04_Wireframe_Interactive.html`: coral `#B96149` trên kem chỉ 4.09:1; muted `#5E766D` 4.64:1 trên `#FAF9F3` nhưng 4.49:1 trên `#F7F5F0`.
- Root cause: palette prototype chọn theo cảm quan, chưa đo contrast.
- Fix: `danger` = `#A0412A` (6.06:1), `textSecondary` = `#4E655D` (5.95:1); giữ teal/kem gốc.
- Prevent: P11 + test contrast tự động cho mọi cặp semantic.
- Verify: `flutter test test/app/theme` pass.

### L-003 — Dùng `ref` của Notifier sau khi provider đã dispose (2026-10-18)
- Detect: widget test golden path ném `UnmountedRefException` khi rời player; lưu phiên cuối cùng (chạy trong `onDispose`) gọi `ref.invalidate(sessionsProvider)` sau một async gap.
- Root cause: controller vừa ghi dữ liệu vừa chịu trách nhiệm làm mới provider khác → phụ thuộc vào vòng đời `ref`.
- Fix: `SessionRepository.changes` (stream) phát sau mỗi lần ghi; `sessionsProvider` tự lắng nghe và `invalidateSelf()`. Controller không còn dùng `ref` sau async gap. Repository bỏ qua notify khi stream đã đóng (app tắt).
- Prevent: P12; widget test thoát player giữa chừng (golden_path_test).
- Verify: `flutter test` 82/82 pass.

### L-004 — Tràn layout khi cỡ chữ hệ thống 150–200% (2026-10-18)
- Detect: ma trận test accessibility (T10) fail 23/54 trường hợp: `RenderFlex overflowed` ở `RoutineCard` (Row tiêu đề + nhãn DEMO) và header player (Row nút Dừng + "Bước n / N"), nhãn offline trong Library.
- Root cause: dùng `Row` cho các cụm chữ có độ dài thay đổi; test cũ chỉ chạy textScale 1.0 trên màn 800×600.
- Fix: đổi sang `Wrap` (xuống dòng tự nhiên) hoặc `Flexible`; ảnh player giới hạn 40% chiều cao để controls luôn trong màn hình; filter Library thành hàng cuộn ngang.
- Prevent: P13 + ma trận render trong `test/accessibility/`. Widget test chạy ở kích thước điện thoại 360×780.
- Verify: `flutter test test/accessibility` 66/66 pass (+ contrast guideline).

### L-005 — Nút điều khiển nằm ngoài màn hình ở chế độ xem từ xa (2026-10-18)
- Detect: widget test bấm "Tạm dừng" không có tác dụng ở máy 360×780; nút nằm dưới vùng nhìn thấy của `ListView`. Ở cỡ chữ 200% nhãn nút xuống 2 dòng làm tràn cột ngang.
- Root cause: đặt controls trong cùng danh sách cuộn với nội dung cỡ lớn; người đứng cách 1–2 m không thể cuộn.
- Fix: ghim controls ở đáy (ngoài vùng cuộn), vòng đếm co theo chiều cao khả dụng, nhãn nút lớn 1 dòng tự co.
- Prevent: test accessibility "keeps Pause and Stop on screen" cho 3 cỡ máy; P14.
- Verify: `flutter test test/accessibility` pass; ảnh chụp emulator.

### L-006 — Thiết kế "xem từ xa" bỏ mất ảnh hướng dẫn (2026-10-18)
- Detect: người dùng hỏi "không có hình ảnh để tham khảo à?". Báo cáo trước còn nói sai rằng chỉ màn ngang thiếu ảnh.
- Root cause: tối ưu cho đồng hồ mà quên mục đích chính của Player là hướng dẫn động tác; không có test khẳng định ảnh có mặt trong mọi bố cục Player.
- Fix: ảnh là trung tâm, tiến độ thành khung quanh ảnh; test `shows a huge step timer…` kiểm `Image` có semanticLabel của bước hiện tại.
- Prevent: P15. Khi báo cáo bố cục, mô tả theo ảnh chụp thực tế của từng hướng màn hình.
- Verify: `flutter test` 218/218; ảnh chụp emulator dọc + ngang.

### L-007 — Test treo do cache asset của `rootBundle` giữa các test (2026-10-18)
- Detect: test thứ 2 trở đi của màn phương Đông không bao giờ thấy dữ liệu; chạy riêng lẻ thì pass.
- Root cause: `rootBundle.loadString` (mặc định `cache: true`, gói phương Đông dùng) lưu Future tạo trong vùng fake-async của test trước; test sau chờ Future đó mãi.
- Fix: `pumpTestApp` gọi `rootBundle.clear()` trước khi dựng app; thêm `pumpUntilFound` cho màn đọc nhiều file asset liên tiếp.
- Prevent: mọi widget test dùng `pumpTestApp`; không dùng `pumpAndSettle` khi màn đang có spinner/animation lặp.
- Verify: `flutter test` 249/249 pass.

### L-008 — Chế độ xem từ xa không cho biết vì sao đồng hồ đứng (2026-10-18)
- Detect: test E2E trên emulator: khi tạm dừng hoặc bị gián đoạn, màn vẫn hiện "còn lại" như đang chạy; dòng "Đang tạm dừng." / "Đã tạm dừng vì ứng dụng bị gián đoạn…" nằm dưới lời hướng dẫn, ngoài màn hình. Trên máy 320×568 cả số đếm cũng sát mép.
- Root cause: chỉ cảnh báo 10 giây được dời lên cạnh số (L-005); các trạng thái khác vẫn ở vùng cuộn. Ảnh chiếm tỉ lệ cố định 40% chiều cao, không tính phần còn lại.
- Fix: một dòng duy nhất ngay dưới số đếm theo ưu tiên: cảnh báo sắp đổi > lý do dừng (chuẩn bị/tạm dừng/gián đoạn/đang tải) > "còn lại"; ảnh dọc tính theo chiều cao còn lại sau khi chừa 430dp. Tách semantics: số đếm một nhãn, dòng trạng thái là liveRegion riêng; "còn lại" thuần không đọc lặp.
- Prevent: P14 mở rộng; test `status is visible without scrolling` (360×780, 320×568).
- Verify: `flutter test` 259/259; emulator hiện dòng gián đoạn màu hổ phách dưới số.

### L-009 — Ảnh hướng dẫn mâu thuẫn chính lời cảnh báo an toàn (2026-10-18)
- Detect: E04 khung 03 giơ tay quá đầu trong khi ghi chú "Không cần nâng quá đầu"; E06 nhấc gối ngang hông trong khi ghi chú "Không cần nâng gối cao". Gói v0.7 chặn phát hành vì lỗi này; trước đó tài liệu 06/07 cũng đã ghi.
- Root cause: ảnh AI được nhận vào mà không đối chiếu từng khung với `safetyNotes` của chính động tác.
- Fix: D12 (sắp lại khung có sẵn, vẽ lại số thứ tự).
- Prevent: test `rejected_frames_test.dart` chặn mã băm các khung đã loại; P16.
- Verify: test fail khi đặt lại khung cũ, pass với khung mới; `flutter test` 271/271.

### L-010 — Đổi trạng thái nội dung nhưng chữ mô tả cũ vẫn còn (2026-10-18)
- Detect: chụp emulator ở D16 thấy thẻ Thư viện ghi "đang chuẩn bị bài tập" và lời giới thiệu ghi "bài tập sẽ được bổ sung sau", dù Bát Đoạn Cẩm đã tập được từ D13.
- Root cause: D13 chỉ sửa màn chi tiết hệ; các chuỗi ARB mô tả trạng thái chung được viết cứng theo giả định "chưa hệ nào tập được"; không có test nào kiểm chữ ở thẻ Thư viện.
- Fix: thẻ đếm số hệ có routine tập được (`playableRoutine`); lời giới thiệu viết trung tính.
- Prevent: khi đổi trạng thái phát hành, grep ARB theo từ khóa trạng thái cũ ("chuẩn bị", "bổ sung sau", "chưa có") và sửa mọi chỗ; chữ mô tả trạng thái phải suy ra từ dữ liệu, không viết cứng.
- Verify: test `library entry counts the playable systems`.

### L-011 — Test chạm trượt khi nội dung mới đẩy phần tử xuống mép màn hình (2026-10-19)
- Detect: thêm "Lịch sử và văn hóa" vào màn hệ, test chạm "1. Song thủ thác thiên" không mở màn thức. Trước đó đã gặp cùng kiểu lỗi ở Cài đặt (thanh điều hướng) và màn chào (logo cao hơn).
- Root cause: `scrollUntilVisible` dừng khi phần tử vừa lộ một phần ở mép; điểm giữa có thể nằm ngoài vùng chạm hoặc dưới thanh điều hướng.
- Fix: `ensureVisible` + settle trước khi `tap`.
- Prevent: sau `scrollUntilVisible`, luôn `ensureVisible` trước khi chạm; nếu có thanh điều hướng đáy thì kéo thêm.
- Verify: `a published form shows its real steps and no warning` pass.

### L-012 — Bảng tạm dừng lệch theme: nền xám mặc định, lớp phủ màu kem (2026-10-19)
- Detect: chủ sản phẩm báo bảng tạm dừng "chẳng ăn nhập gì với theme". Ảnh chụp emulator: nền bảng xám của Material, nút "Dừng hẳn" màu cam san hô; sau lần sửa đầu, lớp phủ phía sau lại thành màu kem sáng.
- Root cause:
  - `AppTheme` không định nghĩa `dialogTheme`, nên dialog dùng màu mặc định sinh từ seed thay vì token.
  - `showDialog` lấy `barrierColor` từ context gọi hàm, mà context này nằm *trên* `Theme(AppTheme.night)` của Player, nên lấy nhầm theme sáng.
- Fix:
  - `DialogTokens` + `dialogTheme` (nền `surfaceElevated`, viền `border`, bo `AppRadius.lg`, lớp phủ = `surface` 80%);
  - bảng lấy cả lớp phủ và theme từ `AppTheme.night`;
  - nút "Dừng hẳn" dùng kiểu nút viền chuẩn của app; logo hoa sen đặt cạnh tiêu đề.
- Prevent: P17.
- Verify: test kiểm tra màu nền bảng = `night.surfaceElevated`, màu lớp phủ = `night.dialogTheme.barrierColor` (độ sáng < 0.05) và có logo; ma trận accessibility 3 cỡ máy (gồm màn ngang 360dp) pass; ảnh chụp emulator.

### L-013 — Nút chính ở cuối form dài nằm ngoài màn hình (2026-10-20)
- Detect: test "mg/dL" không lưu được. flutter_test cảnh báo "derived an Offset (180, 796.7) that would not hit test", vì `ensureVisible` chạy trước khi bố cục đổi (chọn chip), nên nút Lưu vẫn nằm dưới mép 780dp.
- Root cause: nút chính đặt cuối một `ListView` dài. Với người cao tuổi đây cũng là lỗi UX: phải cuộn mới thấy nút Lưu hoặc nút Đồng ý.
- Fix: ghim nút chính (Lưu, Đồng ý và bắt đầu) ở đáy màn hình (`bottomNavigationBar` / `Column` + `Expanded`).
- Prevent: P19.
- Verify: 9 widget test sức khỏe pass, không còn cảnh báo "would not hit test".

### L-014 — Nút Lưu và thông báo lỗi bị bàn phím che (2026-10-20)
- Detect: chạy trên emulator, nhập `128/78/72` nhưng không lưu được. Ảnh chụp: bàn phím che nút Lưu (đang ghim bằng `bottomNavigationBar`). Test sau đó cho thấy thông báo lỗi ở cuối form cũng bị che.
- Root cause:
  - `Scaffold.bottomNavigationBar` không được đẩy lên khi bàn phím mở; chỉ `body` co lại (`resizeToAvoidBottomInset`).
  - L-013 mới kiểm tra lúc không có bàn phím.
- Fix:
  - nút Lưu nằm trong `body` (`Column` + `Expanded` + nút), nên luôn ngay trên bàn phím;
  - phím ✓ của bàn phím cũng lưu;
  - lỗi hiện bằng `errorText` ngay dưới ô nhập.
- Prevent: P19 bổ sung "kể cả khi bàn phím mở". Widget test giả lập `viewInsets` của bàn phím.
- Verify: `Save stays above the on-screen keyboard (L-014)`, `the keyboard ✓ key saves too`; emulator.

### L-015 — Một test hỏng kéo test sau hỏng theo (2026-10-20)
- Detect: test xuất CSV hỏng, rồi test PNG báo `UNIQUE constraint` dù không liên quan.
- Root cause: `openTestDatabase` dùng `inMemoryDatabasePath` dùng chung; test hỏng không chạy tới `app.dispose()`, nên database không đóng và dữ liệu lọt sang test kế. Lỗi gốc của test CSV: ghi file là I/O thật, chạy trong fake-async thì không bao giờ xong.
- Fix:
  - `pumpTestApp` đăng ký `addTearDown` đóng DB;
  - thao tác có I/O thật (ghi file, render PNG) chạy trong `tester.runAsync` và chờ tới khi xong;
  - BOM kiểm trên byte vì `readAsString` tự bỏ BOM.
- Prevent: hạ tầng test tự dọn tài nguyên dùng chung bằng `addTearDown`, không dựa vào việc test chạy tới dòng cuối.
- Verify: toàn bộ 387 test pass; test sức khỏe 40/40.

### L-016 — Bàn phím trên máy người dùng không có dấu "/" để nhập huyết áp (2026-10-20)
- Detect: người dùng báo không gõ được `128/78/72` vì bàn phím không có "/".
- Root cause:
  - Thiết kế một ô dựa vào giả định "`TextInputType.datetime` có '/' trên Android/iOS". Giả định này chưa được kiểm trên bàn phím thật; mỗi bàn phím (Gboard, Samsung, SwiftKey, iOS) có bộ phím số khác nhau.
  - Emulator dùng bàn phím vật lý nên không lộ lỗi.
- Fix (theo cách Omron Connect, Samsung Health, Apple Health làm):
  - 3 ô số riêng (Tâm thu / Tâm trương / Nhịp tim) với `TextInputType.number`, chỉ cần chữ số;
  - tự chuyển ô khi số đã đủ (`wholeNumberComplete`: thêm một chữ số sẽ vượt mức tối đa, ví dụ "128", "78"; "12" hoặc "10" thì chờ);
  - phím phân cách nào có trên bàn phím (`/`, cách, `-`, `.`, `,`) cũng chuyển ô; dán `128/78/72` thì điền đủ 3 ô;
  - ô đầu tự mở bàn phím; ✓ ở ô cuối thì lưu.
- Prevent: P20.
- Verify:
  - test `wholeNumberComplete`, tự chuyển ô, phím phân cách + dán, `keyboardType == number`;
  - emulator: gõ 1-2-8-7-8-7-2 rồi ✓, lưu được 128/78 mmHg + 72 lần/phút.

### L-017 — Sửa được ảnh minh họa không có nghĩa là media đã đủ chuẩn hướng dẫn (2026-10-20)
- Detect: ba bảng Thái Cực có lỗi chữ nhìn thấy và hai tư thế mâu thuẫn metadata; ImageGen có thể sửa trực quan nhưng không xác nhận tính đúng kỹ thuật.
- Root cause: một asset đang đồng thời đóng vai trò học liệu tổng quan và gợi ý tư thế, dễ bị hiểu nhầm là hướng dẫn đã duyệt.
- Fix: tạo file v2 riêng, app vẫn hiện cảnh báo không tập theo tranh; voice/VTT/nhạc để trong review pack, không bundle hoặc nâng trạng thái phát hành.
- Prevent: tách ba cổng độc lập: chất lượng hình/chữ, duyệt chuyên môn, và quyền + đồng bộ audio/video. Chỉ vượt đủ cả ba mới được dùng trong Player.
- Verify: đối chiếu trực quan ba bảng v2; manifest ghi `review-only`, `demoOnly`, `expertReviewRequired`; validator và test bundle phải pass.

### L-018 — Prompt đúng bảng màu vẫn có thể tạo một hệ hình ảnh khác app (2026-10-20)
- Detect: bảng Thái Cực v2 dùng nữ mặc võ phục kem, trong khi listing/series E501/E503 thực tế trong app dùng nam áo teal, quần đen, giày trắng.
- Root cause: prompt khóa màu và không khí nhưng không khóa asset tham chiếu đang phát hành; mô tả “phương Đông” đã lấn át ngôn ngữ hình ảnh thật của hệ thống.
- Fix: tạo v3 với E501/E503 làm reference pack, chỉ ghép vùng ảnh tư thế và giữ nguyên lớp chữ/brand từ v2; cập nhật prompt/manifest.
- Prevent: P21. Không sinh ảnh series từ prompt chữ đơn thuần; mọi lượt phải nhận reference pack cụ thể và qua visual QA so trực tiếp.
- Verify: ba bảng v3 dùng cùng nam áo teal, quần đen, giày trắng và studio kem; catalog/pubspec chỉ bundle v3; validator và visual QA phải pass.

### L-019 — Quy tắc lịch vạn niên viết theo trí nhớ sai ở hai chỗ (2026-10-22)
- Detect: so với ngày tham chiếu từ lịch in, giờ hoàng đạo ngày Giáp Tý ra "Tý Sửu Thìn Tỵ Mùi Tuất" (đúng: "Tý Sửu Mão Ngọ Thân Dậu"); Khổng Minh lục diệu ngày 6/8/2026 ra Tiểu Cát (đúng: Không Vong) và 6/12/2025 ra Lưu Liên (đúng: Tốc Hỷ).
- Root cause: (1) gán nhầm bảng điểm khởi của 12 thần cho chi ngày/chi tháng; (2) công thức lục diệu "tháng + ngày − 2" và "giờ đếm tiếp từ ngày" nhớ sai: nguồn dùng "tháng + ngày − 1" và giờ Lý Thuần Phong cố định theo giờ.
- Fix: sửa quy tắc theo ngày tham chiếu; bảng ghi trong D26.
- Prevent: P22.
- Verify: 10 ngày liên tiếp 22–31/10/2025 + 2 ngày xuất hành khớp nguồn; `flutter test` đạt.

### L-020 — So khớp từ khóa phân biệt hoa thường làm mất kết luận (2026-10-22)
- Detect: test ngày 22/10/2025 cho "xây cất" là Nên tránh thay vì Bình thường, và sao Quỷ không thuận "an táng" dù mô tả ghi "Chôn cất".
- Root cause: từ khóa viết thường, văn bản mô tả bắt đầu bằng chữ hoa ("Khởi tạo…", "Chôn cất…"); `contains` phân biệt hoa thường.
- Fix: chuẩn hóa `toLowerCase()` trước khi so khớp.
- Prevent: test từng sao/Trực cụ thể (Cơ, Quỷ, Phòng, Chủy, Mão…) đối chiếu hướng thuận/ngược; kiểm 400 ngày rằng kết luận khớp tổng phiếu.
- Verify: `flutter test` 505/505.

