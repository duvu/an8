# DECISIONS.md — Quyết định kiến trúc

Mỗi quyết định: bối cảnh → lựa chọn → đánh đổi. Thay đổi quyết định thì thêm mục mới, không sửa lịch sử.

### D01 — `TRACKER.md` thay `IMPLEMENTATION_PLAN.md` (2026-10-18)
Một nguồn duy nhất cho backlog/tiến độ (DRY). `02_Claude_Code_Flutter_Prompt.md` vẫn nhắc `IMPLEMENTATION_PLAN.md`; đọc là `TRACKER.md`.

### D02 — Flutter project ở repo root; chỉ bundle frame + thumbnail (2026-10-18)
`catalog/` và `assets/series/` dùng trực tiếp làm asset, không copy (DRY). `pubspec.yaml` liệt kê `assets/series/E0x/frames/` + `thumbnail.png`; **không** bundle `storyboard.png`, `series_strip.png`, `assets/source/`. Đánh đổi: thêm exercise mới (E08) phải thêm 2 dòng vào `pubspec.yaml`; test `every routine is fully bundled` báo lỗi nếu quên.

### D03 — sqflite thay drift (2026-10-18)
Prompt gợi ý drift. Chọn `sqflite` + SQL viết tay: không cần codegen/build_runner, ít dependency (P10). Kiểu dữ liệu được đảm bảo ở repository (map row ↔ model bất biến) + CHECK constraint trong schema. Migrations: `AppDatabase.migrations` append-only, test áp lần lượt từng bước. Xem lại nếu schema phức tạp lên (nhiều join/quan hệ).

### D04 — Player "animation mode" bằng storyboard, chưa có adapter video/voice (2026-10-18)
Chưa có video/voice đã duyệt → không thêm `video_player`/`just_audio`/`audio_session` (YAGNI). Đồng hồ duy nhất: `AppClock.monotonic()`; `SessionMachine` thuần Dart đã có state `buffering`, `mediaFailed`, `interrupt` để adapter video sau này cắm vào mà không đổi domain/UI. Ngắt hệ thống (cuộc gọi, khóa màn hình, nền) đi qua `AppLifecycleListener` (inactive/hidden/paused) → pause chờ người dùng. Màn hình giữ sáng khi tập (`wakelock_plus`) vì nếu không, khóa màn hình tự động sẽ ngắt mọi buổi tập.

### D05 — Chưa xây pipeline tải offline pack (2026-10-18)
Manifest chưa có `downloadUrl` và chưa có nơi host nội dung đã duyệt. Toàn bộ 5 routine demo được bundle → chạy offline ngay. `MediaAvailability` là điểm mở rộng: pack tải về sẽ là một implementation khác (temp → kích thước + SHA-256 → promote atomically → DB), khi có nguồn nội dung. File bundle không hash lại lúc runtime: `scripts/validate_catalog.py` kiểm hash lúc build, gói cài được ký bởi store.

### D06 — Cổng xuất bản nội dung theo build (2026-10-18)
`ContentVisibility`: release chỉ hiện nội dung `approved` và không `demoOnly`; debug/profile hiện bản xem trước, luôn kèm nhãn `DEMO CONTENT`/banner. Release cho tester: `--dart-define=AN_NHIEN_PREVIEW_CONTENT=true`. Hệ quả: release build không define hiện tại có thư viện rỗng — đúng chủ đích vì chưa có nội dung đã duyệt.

### D07 — Preferences nạp trước frame đầu (2026-10-18)
`main` mở DB, đóng các phiên `inProgress` còn sót (app bị kill → `interrupted`), nạp preferences rồi mới `runApp`, để router quyết định onboarding đồng bộ. Đổi preference: ghi DB trước rồi mới cập nhật state.

### D08 — Chủ sản phẩm duyệt bộ ảnh AI làm nội dung chính thức (2026-10-18)
Theo yêu cầu của chủ sản phẩm: bỏ mọi chỉ dẫn "chưa kiểm duyệt/DEMO" khỏi nội dung đang phát hành và dùng bộ ảnh series E01–E07 làm nội dung chính thức.
- Catalog đổi tên `catalog/catalog.v1.json`, `status: published`, `demoOnly: false`, mọi exercise/routine/media `approved`, version `2026.10.18.1`. `validate_catalog.py` PASS với cổng xuất bản.
- Poster `storyboard.png`/`thumbnail.png` không còn dải "HÌNH MINH HỌA AI • CHƯA KIỂM DUYỆT" (tô lại vùng nền phẳng; frame không đổi). Script `build_series_assets.py` đã bỏ dải này; máy hiện tại thiếu font Noto nên ảnh được sửa trực tiếp.
- Release build giờ hiện nội dung mà không cần `AN_NHIEN_PREVIEW_CONTENT` (D06 vẫn đúng: cổng lọc theo `approved`).
- **Đánh đổi / rủi ro còn lại:** "approved" ở đây là quyết định của chủ sản phẩm, **không phải** kiểm duyệt chuyên môn vận động hay rà soát bản quyền. Metadata giữ `aiGenerated: true` và `rights` ghi đúng thực trạng. Cảnh báo an toàn trong app (Preflight, ghi chú từng động tác, màn An toàn) được giữ nguyên.
- Cơ chế nhãn DEMO/banner/chip trong giao diện vẫn giữ và có test với bộ dữ liệu nháp, để nội dung `draft` thêm sau này vẫn bị gắn nhãn (P03).

### D09 — Nội dung phương Đông: chỉ giới thiệu, hiện cả bản release (2026-10-18)
Gói `an8-east` (v0.1.0) gồm 6 hệ, 60 thức, 5 routine — **tất cả là bản nháp**; mỗi thức chỉ có thẻ tên dùng chung một ảnh minh họa, lời dẫn "không tập theo ảnh", routine gắn `not-playable`. Chủ sản phẩm chọn: hiển thị phần giới thiệu ở mọi bản build.
- Cài gói vào `packages/an_nhien_eastern_content` (path dependency); `an8-east/` (nay đổi tên `An_Nhien_Eastern_Content_DropIn_v0.1/`) giữ nguyên làm bản gốc, loại khỏi analyzer.
- App dùng API của gói để đọc `index.v1.json` + sidecar từng hệ, chuyển sang model có kiểu (`features/eastern`). **Không** ghép 60 exercise / 5 routine nháp vào catalog hay Player.
- Chỉ bundle `assets/catalog/` và `assets/covers/` (đã sửa `pubspec.yaml` của bản cài). Thẻ ảnh từng thức không được đóng gói vì gói yêu cầu không dùng ảnh trang trí để dạy tư thế.
- Giao diện: mục "Dưỡng sinh phương Đông" ở đầu Thư viện → danh sách hệ → trang giới thiệu (ảnh bìa có chú thích "không phải hướng dẫn tư thế", tên thức Việt + gốc, ghi chú, lưu ý an toàn, nguồn). Nhãn "Đang chuẩn bị – chưa có bài tập" / "Đang nghiên cứu nguồn"; không có nút Bắt đầu/Tải.
- Rủi ro: tên Việt các thức chưa được chuyên gia đối chiếu (gói ghi rõ) nhưng hiện ở bản release; ảnh bìa là AI.
- Khi có media người thật + kỹ thuật đã duyệt: thêm exercise/routine vào catalog qua schema v1 (hoặc v2 nếu cần `PracticeSystem`), bundle media tương ứng, giữ cổng P03.

### D10 — Âm báo trong Player; icon sinh từ nguồn thương hiệu (2026-10-18)
- Âm báo dùng **một định dạng M4A** (AAC) cho cả Android và iOS (iOS không phát OGG). Bỏ bộ tên trùng `prepare_next/new_step/...`, giữ tên theo file 07 (`cue_step_soon`, `cue_step_start`, `cue_countdown`, `cue_complete`).
- Thời điểm phát do hàm thuần `sessionCues(before, after)` quyết định từ hai trạng thái liên tiếp; ngưỡng 10 s (`stepEndingWarning`) dùng chung cho cảnh báo trên màn hình và âm báo (chuyển từ token giao diện về tầng application).
- `just_audio` + `audio_session`: phiên âm thanh `playback` + `mixWithOthers` (iOS), `assistanceSonification` + `gainTransientMayDuck` (Android). Âm báo không giành audio focus, không dừng nhạc của người dùng, không kích hoạt xử lý gián đoạn của app. Lỗi phát âm báo bị nuốt (ghi log), không ảnh hưởng phiên tập.
- Icon: nguồn ở `assets/branding/` (không bundle); `scripts/build_app_icons.py` sinh icon nền tảng, chạy lại khi thương hiệu đổi. Icon và âm báo đều đang chờ duyệt (thương hiệu / nghe thử).

### D11 — Gộp Unified Media v0.7 có chọn lọc (2026-10-18)
- **Lấy:** 5 bìa routine (`assets/covers/R0x_cover.webp`, quy ước tên, thiếu thì quay về ảnh động tác đầu); `cue_countdown` đã giảm 6 dB; gói phương Đông v0.7 (thêm `getListingMediaManifest`, catalog/listing/series v0.3).
- **Không lấy:** `storyboard.png`/`thumbnail.png` E01–E07 của v0.7 (bản gốc còn dải "CHƯA KIỂM DUYỆT", ngược D08; khung ảnh giống hệt); 7 thẻ danh mục E01–E07 (in "DRAFT · KHÔNG SỬ DỤNG LÀM HƯỚNG DẪN TẬP", ngược D08); 46 thẻ phương Đông có `coverIsExerciseSpecific=false` (in chuỗi tư thế của hệ bài chung dưới tên thức khác → gây hiểu nhầm); ảnh bước `03_poster_instruction`/`0x_step_*` (gói cấm dùng làm hướng dẫn); ảnh nguồn/collage.
- **Hiển thị 14 thẻ riêng cho thức** (E101–E108, E201, E301, E309, E401, E501, E503) ở danh sách thức và một màn xem riêng, luôn kèm khung "Ảnh minh họa chưa được đối chiếu kỹ thuật. Không tập theo ảnh này". Không đưa vào Player. Danh sách thẻ lấy từ cờ trong `listing_media.v1.json`, pubspec của gói chỉ khai báo 14 file đó; test kiểm thẻ nào có cờ đều được bundle.
- **Mâu thuẫn chờ chủ sản phẩm:** v0.7 `review_gates.json` chặn E04 (khung 03 tay quá vai) và E06 (gối cao, không ghế); app vẫn phát chúng theo D08.

### D12 — Sửa E04/E06 bằng cách sắp lại khung ảnh sẵn có (2026-10-18)
Không có khả năng tạo ảnh mới; dùng lại các ảnh cắt từ ảnh gốc tổng hợp (`scripts/fix_e04_e06.py`):
- **E04:** đứng → tay nâng sang ngang ~45° → giữ ~45° → đứng (khung gốc 1, 4, 4, 1). Bỏ khung giơ tay quá đầu; khung "đặt tay lên vai" cũ (thực chất là xoay vai) cũng bỏ.
- **E06:** đứng → bước thấp chân phải (khung 4 lật ngang) → bước thấp chân trái (khung 4) → bước thấp (lật). Bỏ 2 khung nhấc gối ngang hông.
- Số thứ tự in sẵn trên ảnh được xóa và vẽ lại; ô ảnh trong poster/ảnh nhỏ được vá, chữ hướng dẫn giữ nguyên (lời dẫn không đổi). Catalog `2026.10.18.2`.
- **Còn mở:** E06 vẫn không thấy ghế/chỗ vịn trong ảnh (lời dẫn có nhắc); ảnh lật ngang là ảnh AI, chưa có chuyên gia duyệt. Cần quay lại có ghế (T20).

### D13 — Chủ sản phẩm duyệt Bát Đoạn Cẩm lên final (2026-10-18)
Chủ sản phẩm xác nhận đã duyệt đúng kỹ thuật và yêu cầu đưa lên final; chọn phạm vi "chỉ phần đủ ảnh".
- 8 thức E101–E108 + routine R101 "Bát Đoạn Cẩm 10 phút" vào catalog chính (`2026.10.18.3`), `approved`, `demoOnly=false`, tập được trong Player. Ảnh: 4 ảnh bước v0.3 mỗi thức (32 ảnh, `aiGenerated=true`). Lời từng bước, nhịp thở, số lần lặp, lưu ý chép nguyên văn từ poster của thức để chữ khớp ảnh. Tên hiển thị là tên thuần Việt trên poster ("Hai tay nâng trời"…); tên Hán Việt vẫn ở trang giới thiệu.
- 5 hệ còn lại giữ "Đang chuẩn bị": chỉ 6/52 thức có ảnh riêng (E201, E301, E309, E401, E501, E503) — routine của các hệ đó không đủ ảnh. Tẩy Tủy Kinh vẫn nghiên cứu.
- **Khác với khuyến nghị của gói v0.7/v0.8** (giữ toàn bộ phương Đông ở nháp cho tới khi có chuyên gia ghi tên): quyết định của chủ sản phẩm được ghi tại đây; `rights` ghi rõ chưa rà soát bản quyền độc lập.

### D14 — Player chỉ có một bố cục: chế độ xem từ xa (2026-10-18)
Theo yêu cầu chủ sản phẩm, bỏ bố cục thường, nút chuyển trên Player, công tắc "Xem từ xa" trong Cài đặt và preference `distanceView` (giá trị cũ trong DB bị bỏ qua, không cần migration). Player luôn: nền tối, khung tiến độ quanh ảnh, số lớn, nút ghim đáy. Thay thế phần chuyển đổi của T12. Chuỗi "Khó chịu? Dừng ngay" của bố cục thường không còn; nút Dừng ở đầu màn vẫn luôn hiển thị (P14).

### D15 — Một nút "Tạm dừng"; dừng hẳn qua bảng tạm dừng (2026-10-18)
Theo yêu cầu chủ sản phẩm: bỏ nút "Dừng" ở đầu Player. Bấm "Tạm dừng" dừng đồng hồ ngay và mở một bảng nhỏ giữa màn hình (Dialog, nền tối) với 2 nút lớn 72dp: **Tiếp tục** / **Dừng hẳn** (lưu "chưa hoàn thành", như "Kết thúc sớm" trước đây). Chạm ra ngoài: vẫn tạm dừng, nút lớn hiện "Tiếp tục". Nút Back của hệ thống và lúc quay lại app sau gián đoạn cũng mở bảng này, nên luôn có đường dừng hẳn. Thay bảng "Kết thúc sớm?" (S07) cũ.

### D16 — Đổi tên thành "An", logo hoa sen v1.0, gộp có chọn lọc gói v1.0 (2026-10-18)
Nguồn: `An_Flutter_Media_Culture_Brand_v1.0`.
- **Tên hiển thị "An"**: launcher Android (`android:label`), iOS `CFBundleDisplayName`, tiêu đề app, thông báo nhắc tập, câu an toàn. ID kỹ thuật giữ nguyên (`vn.annhien.an_nhien`, package Dart `an_nhien`, `an_nhien_eastern_content`) để không mất dữ liệu người dùng và không phá import.
- **Logo**: icon launcher tạo lại bằng `scripts/build_app_icons.py` từ ảnh nguồn v1.0 trong `assets/branding/` (bỏ `app_icon_master.svg` cũ). Trong app dùng `packages/an_brand` (`AnLockup`) trên thanh tiêu đề Home và màn chào; không tự vẽ hoa sen khác.
- **Ảnh nội dung lấy từ v1.0**: bìa R01–R05, bìa 6 hệ phương Đông, 60 thẻ thức và catalog nháp (chỉ đổi hash/bytes theo ảnh mới).
- **Không lấy từ v1.0**: (1) ảnh bước E04/E06 — v1.0 vẫn là ảnh lỗi cũ (hash nằm trong `rejected_frames_test`), giữ bản sửa D12; (2) thumbnail/strip/storyboard E01–E07 — bản mới gắn lại dải "HÌNH MINH HỌA AI · CHƯA KIỂM DUYỆT", trái D08.
- **Chưa tích hợp**: gói `an_nhien_cultural_content` (67 bài "Tìm hiểu", `editorial_draft`), 6 nhạc nền, video intro/outro 2 giây (không có video hướng dẫn để ghép).

### D17 — Nhạc nền + phần "Tìm hiểu" (2026-10-19)
Chủ sản phẩm yêu cầu làm cả hai.

**Nhạc nền.**
- 3 bản được bundle, đúng số bản mà các bài tập được hiện dùng:
  - Buổi sáng: `Sáng Bình Yên.mp3`, bản Suno của chủ sản phẩm theo prompt M1, dùng cho R01–R04;
  - Buổi tối: R05;
  - Khí công: R101.
- 3 bản Ngũ Cầm Hí, Lục Tự Quyết, Thái Cực chưa bundle vì chưa có bài tập dùng.
- `scripts/build_music.py` chuẩn hóa về −23 LUFS (nguồn v1.0 ở −37, Suno ở −15), 48 kHz stereo AAC, fade 2 s/3 s để vòng lặp không giật.
- Chọn bản theo tag của routine (`musicFor`). Nhạc chỉ chạy khi phiên đang đếm ngược hoặc đang tập; tạm dừng, gián đoạn, đang tải hay lỗi thì dừng; kết thúc thì stop.
- Công tắc "Nhạc nền khi tập", mặc định bật. Dùng chung audio session với âm báo: trộn với âm thanh khác, không giành focus.

**Tìm hiểu.** Nguồn: gói `packages/an_nhien_cultural_content` (`editorial_draft`).
- Hiển thị ở mọi bản build, như giới thiệu phương Đông (D09).
- Vị trí:
  - mục "Tìm hiểu" cuối màn thức;
  - màn riêng mở từ từng bước trong chi tiết bài tập (67 động tác);
  - "Lịch sử và văn hóa" ở màn hệ;
  - "Chuyện kể" (6 bài) ở danh sách hệ.
- Mọi chỗ đều có chú thích "do An biên tập, chưa được chuyên gia thẩm định, không phải hướng dẫn kỹ thuật hay lời khuyên y tế".
- Không có nút Nghe vì chưa có bản ghi âm. Không phát gì trong Player, theo chính sách nội dung mục 7.
- Chỉ bundle JSON, nguồn tham khảo và 6 kịch bản chuyện kể. Kịch bản từng động tác/hệ (TXT) và các bài viết `.md` trùng nội dung JSON nên không bundle.
- `historicalNote` dạng "… xem tại <slug>." chỉ là con trỏ tới hồ sơ hệ, nên bị bỏ khi đọc dữ liệu.
- Hồ sơ "basics" (bộ cơ bản) chưa có chỗ hiển thị.

### D18 — Theo dõi chỉ số sức khỏe (2026-10-20)
Chủ sản phẩm yêu cầu theo dõi các chỉ số: cân nặng, chiều cao, BMI, huyết áp, nhịp tim, đường huyết và các chỉ số thường theo dõi ở người cao tuổi.

**Phạm vi.**
- Người dùng **tự nhập**: cân nặng, chiều cao, huyết áp (tâm thu/tâm trương), nhịp tim lúc nghỉ, đường huyết (lúc đói / sau ăn 2 giờ / bất kỳ; nhập mmol/L hoặc mg/dL, lưu mmol/L), SpO2, nhiệt độ, vòng eo.
- BMI tự tính từ cân nặng và chiều cao gần nhất.
- Cảnh báo giảm cân ≥5% trong 6 tháng.
- Không có Health Connect, Apple Health, thiết bị đo hay đồng bộ đám mây (PRD §2.2).

**Điều kiện PRD §8.6** (PRD ghi "không lưu bệnh lý ở MVP; nếu cần phải có đồng ý, bảo vệ dữ liệu, retention, rà soát pháp lý"):
1. **Đồng ý:** tab Sức khỏe hiện màn giải thích; chỉ lưu sau khi bấm "Đồng ý và bắt đầu". Preference `healthConsent`.
2. **Bảo vệ dữ liệu:**
   - bảng `health_measurements` (migration v2, chỉ nối thêm) trong SQLite trên máy, không gửi đi đâu;
   - Android `allowBackup="false"` để dữ liệu không lên Google Drive;
   - iOS chưa loại khỏi sao lưu iCloud vì cần code native và máy macOS để kiểm (rủi ro mở).
3. **Lưu giữ (retention):** xóa từng số đo; Cài đặt có "Xóa toàn bộ dữ liệu sức khỏe" (xóa hết và rút lại đồng ý).
4. **Rà soát pháp lý:** **chưa làm**. Gắn vào T11 trước khi phát hành (Nghị định 13/2023/NĐ-CP xếp dữ liệu sức khỏe là dữ liệu cá nhân nhạy cảm).

**An toàn (PRD §3, §9): không chẩn đoán.**
- Chỉ ghi "Trong / Ngoài khoảng tham khảo / Cần chú ý ngay", kèm lời khuyên đo lại và hỏi bác sĩ; ngưỡng nguy hiểm thì kèm "gọi 115".
- Không dùng chữ "tăng huyết áp" hay "tiểu đường".
- Trạng thái luôn có biểu tượng + chữ, không chỉ dựa vào màu.
- Mọi màn có chú thích "không thay thế khám bệnh".
- Ngưỡng đang dùng (`health_assessment.dart`) **cần bác sĩ duyệt** (T11):

| Chỉ số | Ngoài khoảng tham khảo | Cần chú ý ngay | Nguồn |
|---|---|---|---|
| Huyết áp đo tại nhà | ≥135/85 hoặc <90/60 mmHg | ≥180/120 mmHg | ESC/ESH 2018, Hội Tim mạch VN 2018; AHA (cơn tăng huyết áp) |
| Nhịp tim lúc nghỉ | <60 hoặc >100 lần/phút | — | AHA |
| Đường huyết | lúc đói ≥7,0; sau ăn hoặc bất kỳ ≥11,1 mmol/L | <3,9 hoặc ≥16,7 mmol/L | ADA 2024 |
| SpO2 | <95% | ≤92% | Hướng dẫn đo SpO2 tại nhà của NHS |
| Nhiệt độ | ≥37,5 hoặc <35,5 °C | ≥39,5 °C | thông lệ lâm sàng |
| BMI (người châu Á) | <18,5 · 23–24,9 thừa cân · ≥25 béo phì | — | WHO 2004, Bộ Y tế |
| Cân nặng | giảm ≥5% trong 6 tháng | — | tiêu chí GLIM |

Cân nặng, chiều cao và vòng eo chỉ theo dõi xu hướng, không đánh giá (vòng eo cần biết giới tính, mà app không hỏi).

**Giao diện.**
- Tab thứ 3 "Sức khỏe".
- Thẻ từng chỉ số (số gần nhất, giờ đo, trạng thái) và thẻ BMI.
- Màn chi tiết: khoảng tham khảo, biểu đồ `CustomPainter` (không thêm thư viện; 30 lần đo gần nhất, có nhãn tóm tắt cho trình đọc màn hình) và danh sách các lần đo.
- Form nhập: nhận cả dấu phẩy lẫn dấu chấm; kiểm tra lỗi gõ theo khoảng hợp lệ, số trên phải lớn hơn số dưới, không nhận giờ đo trong tương lai; nút Lưu ghim ở đáy.
- PRD §8.6 "Không lưu câu trả lời về bệnh lý" được thay bằng quyết định này cho phần số đo. App vẫn không hỏi bệnh lý hay thuốc.
- **D18 bổ sung (2026-10-20, theo yêu cầu chủ sản phẩm):**
  - Huyết áp nhập **một dòng** theo thứ tự trên máy đo: `128/78/72` = tâm thu/tâm trương/nhịp tim; nhịp tim không bắt buộc (`128/78`). Dấu cách và `-` cũng được dùng làm dấu ngăn cách.
  - Có nhịp tim thì lưu thêm một số đo "Nhịp tim" cùng thời điểm, để biểu đồ và đánh giá nhịp tim dùng chung dữ liệu.
  - Bàn phím `datetime` (có phím "/").
  - Lời khuyên sau khi lưu gộp cả huyết áp lẫn nhịp tim.

### D19 — Xuất dữ liệu sức khỏe ra CSV và ảnh (2026-10-20)
Chủ sản phẩm yêu cầu. Nút "Xuất dữ liệu (CSV, ảnh)" ở tab Sức khỏe mở màn Xuất dữ liệu.
- **CSV:** mọi số đo, cũ trước mới sau; cột Ngày giờ đo, Chỉ số, Giá trị, Giá trị 2 (tâm trương), Đơn vị, Thời điểm đo đường huyết, Ghi chú.
  - Định dạng: RFC 4180 (dấu phẩy, CRLF, số thập phân dùng dấu chấm); UTF-8 có BOM để Excel đọc đúng tiếng Việt.
  - Ô bắt đầu bằng `= + - @` (không phải số) được thêm `'` phía trước để Excel không chạy như công thức (chặn chèn công thức).
  - Excel cài vùng Việt Nam (dấu phân cách `;`) có thể cần dùng chức năng Import; Google Sheets mở thẳng được.
- **Ảnh PNG:** bảng tóm tắt `HealthReport`: logo An, giờ tạo, số đo gần nhất kèm trạng thái, BMI, biểu đồ cho chỉ số có từ 2 lần đo trở lên, chú thích. Luôn dùng theme sáng để in/đọc rõ, chụp ở `pixelRatio` 2, và hiển thị **xem trước** đúng ảnh sẽ xuất.
- **Gửi file:** qua bảng chia sẻ của hệ thống (`share_plus`, sau interface `FileSharer`), người dùng tự chọn nơi gửi; app không tự tải lên đâu. Màn hình nhắc "chỉ gửi cho người bạn tin tưởng".
- **File tạm:** nằm trong thư mục cache `exports/`; lần xuất sau xóa file cũ trước để dữ liệu sức khỏe không tồn đọng.
- **Dependency mới:** `share_plus` (bảng chia sẻ chuẩn) và `path_provider` (vốn đã là dependency gián tiếp).

### D20 — Cân nặng tham khảo theo chiều cao trong thẻ BMI (2026-10-20)
Chủ sản phẩm yêu cầu: chiều cao người trưởng thành hầu như không đổi, nên thẻ BMI cần cho biết cân nặng khuyến nghị.
- **Khoảng cân nặng:** những cân nặng cho BMI trong mức bình thường người châu Á [18,5; 23) (cùng mốc với D18), tính từ chiều cao gần nhất. Làm tròn **vào trong**, bước 0,1 kg, để mọi số hiển thị đều thật sự "bình thường". Ví dụ 160 cm → 47,4–58,8 kg.
- **Vị trí so với khoảng:** "nằm trong khoảng" hoặc "nhiều hơn / ít hơn {x} kg". Số kg làm tròn lên 0,1 và luôn khớp với xếp loại BMI (cùng một hàm quyết định).
- **Chỉ có chiều cao, chưa có cân nặng:** vẫn hiện khoảng tham khảo.
- **An toàn (P18):**
  - dùng chữ "tham khảo", không dùng "mục tiêu";
  - khi ngoài khoảng, nhắc người cao tuổi đừng tự ăn kiêng hay ép tăng cân, và hỏi bác sĩ trước khi đặt mục tiêu (giảm cân không chủ ý ở người già là dấu hiệu nguy cơ, xem cảnh báo sụt cân ở D18).
- **Chưa làm:** ảnh xuất (D19) vẫn chỉ ghi BMI (YAGNI).
- **Mở:** một số hướng dẫn lão khoa chấp nhận BMI cao hơn (khoảng 22–27) ở người ≥ 65 tuổi; bác sĩ cần duyệt mốc này cùng các ngưỡng D18 (T11).

### D21 — Gộp gói v9: bảng tổng quan Thái Cực Quyền 24 thức (2026-10-20)
Nguồn: `An_Flutter_Media_Culture_Brand_v9`. So với v1.0, v9 chỉ thêm 3 bảng tổng quan (Thức 1–8, 9–16, 17–24), `taichi24_overview.v9.json` và một ghi chú markdown; mọi file khác giống hệt v1.0.
- **Lấy:** 3 bảng bản WebP (~200 KB mỗi bảng) và file JSON, vào gói `an_nhien_eastern_content`. Gói có thêm `getTaichi24Overview()`. Pubspec của gói v9 không khai báo `assets/education/`, nên ảnh sẽ không được đóng gói nếu chép nguyên; ở đây khai báo từng file.
- **Không lấy:** bản PNG 1,8 MB (trùng nội dung); pubspec v9 khai báo toàn bộ `assets/listing/` và `assets/series/` (ngược D09/D11/D13).
- **Hiển thị:**
  - mục "Bảng tổng quan các thức" ở trang Thái Cực Quyền 24 thức, gắn với hệ qua `routineId` (R105);
  - mỗi bảng mở màn riêng, phóng to tối đa 4 lần;
  - luôn kèm khung "chưa được đối chiếu kỹ thuật, không tập theo tranh này";
  - không đưa vào Player, không đổi trạng thái "Đang chuẩn bị" của hệ.
- **Lỗi thấy được trên ảnh, chưa sửa** (chữ in sẵn trong ảnh AI; cần tạo lại ảnh):
  - chính tả: thức 6 "Đảo quyến quăng" (đúng: "quyển"), thức 22 "Như phong tự bể" (đúng: "bế"), thức 24 "Thu thể" (đúng: "Thu thế");
  - kỹ thuật cần chuyên gia xem:
    - thức 12 Cao thám mã vẽ nhấc gối cao, trong khi bài chuẩn là bộ hư (mũi chân chạm đất);
    - thức 13 (đá gót phải) và 15 (đá gót trái) vẽ cùng một hướng đá;
    - thức 11 dùng lại dáng của thức 9 (chấp nhận được vì là "Đơn tiên lặp").

### D22 — Media review pack Thái Cực 24 v2 (2026-10-20)
- Tạo ba bảng tổng quan v2 bằng ImageGen, giữ bố cục v9: sửa chữ thức 6/22/24; chỉnh minh họa thức 12 về bộ hư và thức 15 sang hướng đá trái. App tham chiếu v2; v1 giữ lại ngoài bundle để đối chiếu.
- Các bảng vẫn là học liệu tham khảo `demoOnly`, luôn kèm cảnh báo "không tập theo tranh"; chỉnh ảnh không thay thế duyệt chuyên gia.
- Gom 24 kịch bản lời dẫn + 24 VTT nháp vào `review_media/taichi24`; không bundle vì chưa có voice/video cuối.
- Thêm nhạc nền candidate 2 phút, AAC 48 kHz stereo, chuẩn hóa từ −36,7 lên −23,1 LUFS; không bundle/không phát trong app cho đến khi routine Thái Cực được duyệt và chủ sản phẩm xác nhận quyền + nghe duyệt.

### D23 — Khóa phong cách ảnh Thái Cực theo asset đang có trong app (2026-10-20)
- Bản v2 dùng nữ áo kem, không khớp listing/series E501/E503 trong app đang dùng nam áo teal, quần đen, giày trắng, studio kem.
- Bản v3 lấy E501/E503 làm reference pack bắt buộc, thay chỉ vùng ảnh tư thế; chữ, logo, số, card và nền bảng giữ từ v2.
- App chỉ bundle v3; v1/v2 giữ ngoài bundle để đối chiếu. Đây là sửa tính nhất quán thương hiệu, không phải duyệt kỹ thuật động tác.


### D24 — Nhắc đứng dậy vận động trong ngày (2026-10-22)
- Thông báo local lặp hằng ngày trong khoảng giờ người dùng chọn (mặc định 08:00–18:00, mỗi 60 phút; lựa chọn 45/60/90/120 phút). Lần đầu sau `giờ bắt đầu + khoảng cách`, lần cuối không quá giờ kết thúc.
- Kiểu nhắc: Chỉ thông báo / Rung (mặc định) / Chuông. Android cố định âm và rung theo kênh nên mỗi kiểu một kênh (`break_reminder_<kiểu>`). iOS không có công tắc rung: "Rung" hoạt động như "Chỉ thông báo" (ghi trong màn Cài đặt).
- 3 câu nhắc luân phiên (đứng dậy đi lại, vươn vai + uống nước, nghỉ mắt). Chỉ là lời nhắc lối sống, không phải khuyến cáo y khoa/chẩn đoán.
- Dùng chung quyền thông báo và báo thức không chính xác với nhắc tập (có thể trễ tới ~1 giờ trên Android). Không thêm package. Không cần migration (preferences là key-value).

### D25 — Sửa các điểm vi phạm SOLID (2026-10-22)
- **ISP/SRP:** `ReminderScheduler` tách thành `NotificationPermission`, `DailyReminderScheduler`, `BreakReminderScheduler`; plugin dùng chung qua `NotificationGateway`. Việc bật/tắt nhắc nhở chuyển từ `PreferencesController` sang `ReminderActions`.
- **SRP/OCP:** `SettingsScreen` chỉ ghép các section (`PracticeSettingsSection`, `DailyReminderSection`, `BreakReminderSection`, `HealthDataSection`).
- **SRP:** logic form thêm chỉ số sức khỏe chuyển vào domain (`MeasurementDraft`, `pressureInputEffect`); màn hình chỉ giữ controller ô nhập và hiển thị.
- **DIP:** `HealthActions` nhận repository, `HealthConsent` và `IdGenerator` qua constructor (không còn đọc `Ref` hay `preferencesProvider`); `allByMetricProvider` chuyển sang tầng application; `IdGenerator` dùng chung cho session và health.
- **SRP:** `SessionRecorder` giữ việc lưu bản ghi phiên; `SessionController` chỉ còn điều phối máy trạng thái và đồng hồ.
- **OCP:** `assess` dùng bảng quy tắc theo chỉ số; test bắt buộc mọi chỉ số có khoảng tham khảo đều có quy tắc.
- `distance_timer_view.dart` chia thành 4 file.

### D26 — Lịch vạn niên: lịch âm/dương, ngày đẹp giờ đẹp, xuất hành (2026-10-22)
Tính năng mới ngoài PRD, theo yêu cầu của chủ sản phẩm. Màn `/calendar` (mở từ biểu tượng lịch ở Trang chủ): lưới tháng (thứ Hai đầu tuần) có ngày dương + ngày âm, chọn ngày xem chi tiết. Không cần backend, không lưu dữ liệu, không thêm package.
- **Lịch âm:** thuật toán thiên văn của Hồ Ngọc Đức (tân nguyệt + kinh độ Mặt Trời, múi giờ UTC+7), hợp lệ 1900–2199; ứng dụng giới hạn 1900–2100. Có tháng nhuận.
- **Can Chi:** ngày theo số ngày Julian; năm, tháng theo tháng âm (tháng 1 = Dần, "ngũ hổ độn").
- **Tiết khí:** 24 tiết theo kinh độ Mặt Trời; **tháng tiết** (đổi vào chính ngày Tiết) dùng để tính Trực và hoàng đạo, như lịch truyền thống. Can Chi tháng hiển thị theo số tháng âm (khác tháng tiết ở vài ngày đầu/cuối tháng).
- **Hoàng đạo/hắc đạo ngày và giờ:** 12 thần, 6 thần hoàng đạo (Thanh Long, Minh Đường, Kim Quỹ, Bảo Quang, Ngọc Đường, Tư Mệnh); điểm khởi: Dần/Thân → Tý, Mão/Dậu → Dần, Thìn/Tuất → Thìn, Tỵ/Hợi → Ngọ, Tý/Ngọ → Thân, Sửu/Mùi → Tuất (ngày: theo chi tháng tiết; giờ: theo chi ngày).
- **12 Trực:** `(chi ngày − chi tháng tiết) mod 12`; mô tả ngắn chỉ gồm các công dụng có nguồn.
- **Xuất hành:** Khổng Minh lục diệu của ngày = `(tháng âm + ngày âm − 1) mod 6` (Đại An, Lưu Liên, Tốc Hỷ, Xích Khẩu, Tiểu Cát, Không Vong); giờ theo Lý Thuần Phong cố định (Tý/Ngọ Đại An … Tỵ/Hợi Không Vong); hướng Hỷ thần / Tài thần theo can ngày. "Giờ đẹp xuất hành" = giờ hoàng đạo có cung tốt.
- **Đánh giá ngày:** điểm giản lược = hoàng đạo (+1)/hắc đạo (−1) + trực tốt (+1)/xấu (−1); chỉ để tham khảo.
- **Kiểm chứng (L-019):** đối chiếu với lịch in và các trang lịch: 10 ngày liên tiếp 22–31/10/2025 (ngày âm, Can Chi, Trực, 6 giờ hoàng đạo, Hỷ/Tài thần), ngày 22/10/2025 là Thiên Lao hắc đạo, ngày 6/8/2026 (24/6 Nhâm Tý) Không Vong, 6/12/2025 (17/10) Tốc Hỷ; Tết 2023–2026, tháng nhuận 2/2023, Rằm Trung thu 2025. Nguồn: quantrimang.com/lich-am, baohatinh.vn, baolamdong.vn.
- **Nội dung chưa được chuyên gia văn hóa/lịch pháp thẩm định** (thêm vào T11): màn luôn hiện dòng "chỉ mang tính tham khảo… không thay thế lời khuyên y tế, pháp lý, tài chính". Các trường phái khác nhau có thể cho kết quả khác (ví dụ hướng Tài thần, mô tả Trực); đây là một bộ quy tắc phổ biến, không phải duy nhất.
- **Chưa làm (YAGNI):** 28 sao (nhị thập bát tú), sao tốt/xấu, nên/kỵ theo từng việc (cưới hỏi, động thổ…), ngày lễ/giỗ, nhắc theo lịch âm.

### D27 — Bổ sung 28 sao nhị thập bát tú vào lịch vạn niên (2026-10-22)
- Mỗi ngày có một sao trong vòng 28 ngày liên tục; mốc: 22/10/2025 là sao Cơ. Vì 28 chia hết cho 7, hành của sao theo thứ trong tuần (Mộc thứ Năm, Kim thứ Sáu, Thổ thứ Bảy, Thái dương Chủ nhật, Thái âm thứ Hai, Hỏa thứ Ba, Thủy thứ Tư) — test kiểm trên 3000 ngày.
- Bảng 28 sao (tên, hành, con vật, kiết/bình/hung tú, "nên làm", "kiêng cữ") lấy từ 28 ngày liên tiếp 22/10–18/11/2025 của cùng một lịch tham chiếu (quantrimang.com/lich-am), rút gọn nguyên văn, không tự bổ sung. Phân loại theo nhãn của nguồn: 11 kiết, 5 bình (Giác, Khuê, Sâm, Tỉnh, Tinh), 12 hung. Đối chiếu thêm 6/8/2026 (Khuê) và 1/1/2000 (Vị).
- Màn chi tiết ngày có mục "Sao nhị thập bát tú": tên, hành, con vật, loại (chữ + biểu tượng, không chỉ dựa vào màu), nên làm, kiêng cữ.
- **Không đổi "Đánh giá ngày"** (vẫn chỉ gồm hoàng đạo/hắc đạo + Trực): chưa có quy tắc gộp sao có nguồn; tránh tự đặt trọng số.
- Cùng rủi ro nội dung như D26: chưa được người am hiểu lịch pháp thẩm định (T11); các sách khác có thể ghi nhãn tốt/xấu hoặc con vật khác (ví dụ sao Giác, Tinh).

### D28 — Nên làm / kỵ theo từng việc (2026-10-22)
- Sáu việc: cưới hỏi, khai trương, xây cất/động thổ, xuất hành, an táng/sửa mồ mả, kiện tụng. Mỗi việc có kết luận **Nên làm / Bình thường / Nên tránh** kèm lý do (thuận/ngược) để người dùng thấy vì sao.
- **Không thêm bảng nội dung mới.** Kết luận được suy ra từ các nguồn đã kiểm chứng (D26, D27): mỗi nguồn bỏ một phiếu thuận hoặc ngược, tổng phiếu quyết định, hòa là bình thường:
  - hoàng đạo (+) / hắc đạo (−) cho mọi việc trừ kiện tụng;
  - Trực: từ chữ trong mô tả ("tốt cho/hợp …" thuận, sau "tránh" ngược); Trực xấu (Phá, Nguy, Bế) ngược với mọi việc quan trọng;
  - sao nhị thập bát tú: việc nằm trong "kiêng cữ" thì ngược, trong "nên làm" thì thuận (tìm theo từ khóa, không phân biệt hoa thường);
  - Khổng Minh lục diệu của ngày (chỉ cho xuất hành): cung tốt thuận, cung xấu ngược.
- Kiện tụng chỉ có thể bị khuyên tránh, không bao giờ "nên làm".
- **Đây là quy tắc gộp của ứng dụng, không phải một trường phái truyền thống:** lịch in còn nhiều sao tốt/xấu khác (Âm thác, Ngũ quỷ, Thổ ôn…) và đối chiếu theo tuổi gia chủ; ứng dụng không xét các yếu tố đó. Màn hình ghi rõ "tổng hợp… chỉ để tham khảo".
- Chưa làm: xét tuổi gia chủ, các sao tốt/xấu phụ, việc khác (nhập trạch, nhập học, cầu tài…).
