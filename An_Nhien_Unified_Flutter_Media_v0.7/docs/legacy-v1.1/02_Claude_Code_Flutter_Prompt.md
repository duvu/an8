# PROMPT TRIỂN KHAI CHO CLAUDE CODE — AN NHIÊN (FLUTTER)

> Dán toàn bộ nội dung phần **PROMPT** dưới đây vào Claude Code ở root workspace. Đính kèm hoặc đặt cùng repo các tệp `01_PRD_An_Nhien_Flutter.md`, `03_Wireframe_Spec.md`, `04_Wireframe_Interactive.html` và `05_Content_Catalog_And_Series.md`. Nếu tên file thay đổi, tự dò tài liệu tương ứng.

---

## PROMPT

Bạn là **Lead Flutter Engineer + Mobile Architect + Product Engineer + QA Lead**. Nhiệm vụ: **thiết kế và triển khai MVP ứng dụng mobile “An Nhiên — Dưỡng sinh mỗi ngày” trên Flutter** cho Android/iOS, dựa trên `01_PRD_An_Nhien_Flutter.md`, `03_Wireframe_Spec.md` và `05_Content_Catalog_And_Series.md`, sử dụng wireframe HTML tương tác làm tham chiếu trải nghiệm, không dùng HTML/WebView làm UI Flutter.

### 1. Nguyên tắc sản phẩm không thể thương lượng

1. Người dùng có thể mở app và vào bài tập nhanh; player là thành phần quan trọng nhất. Người trung niên/lớn tuổi dùng được: text lớn, controls lớn, rõ ràng, hỗ trợ TalkBack/VoiceOver và textScale cao.
2. **Flutter thuần + Dart**, Android và iOS. Không Expo, không React Native, không WebView để dựng toàn bộ ứng dụng.
3. Video người thật là media chính; animation Rive chỉ là nội dung phụ trợ. Nếu chưa có media được phê duyệt, tạo **placeholder hiển thị rõ 'Demo — chưa phải hướng dẫn tập'**, có hỗ trợ preview UX, không dùng animation AI chưa kiểm duyệt để hướng dẫn người dùng thực hành và không giả định asset tồn tại.
4. Offline-first, local-first, không đăng nhập hay backend trong MVP. Có starter routine dùng offline; routines còn lại có cơ chế download pack và xử lý lỗi rõ ràng.
5. **Không viết claim chữa bệnh, không suy đoán hoặc cá nhân hóa y khoa**. Nội dung vận động chỉ được xuất bản sau khi có `reviewStatus=approved` từ người phụ trách chuyên môn; content chưa approved không xuất hiện như bài được khuyến nghị. Không cổ vũ nín thở, ấn xoang cảnh hoặc bẻ cổ mạnh.
6. Không viết code giả, controls chết, empty callbacks hay TODO giả vờ hoàn thành. Phân biệt chức năng thật, demo/dev only và phần đang thiếu.
7. Luôn luôn chạy kiểm thử, ghi lại kết quả, liệt kê các hạn chế chưa giải quyết. Không tuyên bố hoàn thành nếu chưa có chạy app/kiểm tra thực tế phù hợp.

### 2. Cách thực hiện

- Đọc tài liệu và khảo sát cấu trúc repository trước. Nếu repo có Flutter project, **giữ tương thích và tái sử dụng** kiến trúc thành phần có thể dùng được; không xóa/thay thế thiếu kiểm soát.
- Tạo `IMPLEMENTATION_PLAN.md`: backlog theo mức độ ưu tiên, dependency, rủi ro, acceptance criteria và trạng thái thực tế.
- Chọn **vertical slice** trước thay vì tạo hàng loạt màn hình dummy: Home → Routine Detail → Preflight → Session Player → Summary; hoạt động bằng nội dung demo an toàn và có thể thử nghiệm trên thiết bị.
- Sau vertical slice, xây Library, downloads, progress, reminders, settings và onboarding.
- Tạo `DECISIONS.md` mô tả quyết định kiến trúc và trade-offs; không thêm package nếu Flutter core đã đủ giải quyết.
- Không hỏi lặp các quyết định đã có trong PRD; khi tài liệu chưa quyết định, chọn phương án đơn giản và ghi rõ giả định.
- Mỗi milestone: `dart format`, `flutter analyze`, `flutter test`; kiểm tra widget/integration khi môi trường cho phép; ghi output ngắn vào `IMPLEMENTATION_PLAN.md`.

### 3. Kiến trúc bắt buộc

**Preferred stack:** Flutter stable được pin trong repo; Dart; Material 3; `flutter_riverpod` cho dependency injection/state; `go_router` cho navigation; `video_player` cho video; `just_audio` + `audio_session` nếu voice cần file tách riêng; `drift`/`drift_flutter` cho SQLite; `path_provider` + downloader có kiểm tra checksum; `flutter_local_notifications` cho reminder; `rive` tùy chọn cho asset đã kiểm duyệt. Dùng `flutter_localizations`/`intl` khi cần. Tất cả phiên bản resolve theo SDK thực tế, không copy blindly một version cứng.

**Feature-first structure**:
```
lib/app/{router,theme,localization}/
lib/core/{errors,clock,media,accessibility,logging}/
lib/features/{onboarding,catalog,routine,session,downloads,history,settings,safety}/
lib/data/local/{database,daos,migrations}/
assets/{catalog,posters,media,audio,animations}/
test/; integration_test/
```
Widgets hiển thị state, không chứa truy vấn DB, download logic, logic phân phối timeline hay business rules. Dùng ViewModel/Notifier, domain models bất biến, Repository đơn nguồn dữ liệu, service adapter cho plugin. Dependency direction một chiều. Tránh generic repository phức tạp không có lý do.

**Design system:** palette xanh teal đậm/kem từ asset series (tham khảo #073F3B, #0A5249, #FAF9F3); không hardcode màu trong widgets; tách primitive palette và semantic color tokens. Các token tối thiểu: `surface`, `surfaceElevated`, `textPrimary`, `textSecondary`, `border`, `accent`, `onAccent`, `danger`, `focusRing`. Thống nhất typography, spacing scale, radius, icon sizing, button variants, empty/error/loading; tôn trọng safe areas, dynamic text scaling, reduced motion. Tương phản chữ thường >= 4.5:1; hit targets >=48dp; semantic labels Việt cho controls. Giao diện phù hợp Android và iOS; không cần pixel-identical nếu làm giảm native accessibility.

### 4. Domain schema và nội dung

Implement models/migrations có version:
- `Exercise` và `Routine` (id, version, title, description, difficulty, position, approved status, locale, focus, safety notes).
- `RoutineStep` (order, exercise reference, durationMs, cues, mediaVariantId).
- `MediaAsset` (kind: video/rive/poster/audio, checksumSha256, source, local path, captions, locale, bytes, license, review state).
- `DownloadPack` (packId, version, total bytes, state, actual path, timestamp, lastError).
- `WorkoutSession` (session id, routine/version, start/end, active duration, completed/abandoned/interrupted).
- `Preferences` và `Reminder`.

Seed data mô phỏng R01–R05 và E01–E07 theo PRD và `catalog/catalog.draft.v1.json`. **Bắt buộc dùng catalog như dữ liệu không hardcode trong widget/Flutter code.** Triển khai `ContentCatalogRepository` + `CatalogDataSource` + `BundledCatalogDataSource` và parse manifest theo schema. Không triển khai CMS, admin portal hoặc backend catalog trong MVP. Kiểm tra checksum và reference/versions. Giao diện chỉ đọc repository nên sau này thêm remote/CMS adapter mà không phải viết lại UI/domain. Các media files trong `assets/series/E01..E07` là bộ ảnh series AI **chỉ dùng dev preview**, còn `assets/source` chỉ để tham khảo, không đóng gói trong app release. Vẫn phải có placeholder/quy trình media thật được kiểm duyệt. **Không đánh dấu media/chuyển động chưa kiểm duyệt là đã được duyệt.** Cho phép chế độ developer preview với badge 'DEMO CONTENT'; production build lọc bỏ nội dung demo/unapproved. Hãy tạo các cấu trúc để đội nội dung nhập media thật sau này mà không phải thay kiến trúc.

### 5. Implement Session Player chuẩn

Tạo state machine tường minh:
`idle → preparing → countdown → playing ↔ paused` cùng các nhánh `buffering`, `completed`, `abandoned`, `interrupted`, `error`.

- `Play`, `Pause`, `Resume`, `Previous`, `Next`, `Exit`, `Retry` đều có hành vi, loading/error rõ.
- Countdown 3 giây, thời gian từng step/tổng bài rõ; bỏ qua bước phải giải quyết thời lượng session chính xác.
- **Video mode:** dùng vị trí media làm đồng hồ nguồn. Buffering không làm tăng tiến độ; khi video lỗi có Retry/Skip an toàn; controller phải được dispose. Voice trong video (khi có) là một timeline đồng bộ; captions/toggle mute vẫn hoạt động.
- **Animation mode:** dùng clock monotonic, không dùng số lần tick làm thời gian đã tập; cue/lời dẫn dựa trên offset; pause/resume không làm lệch nhịp và không replay audio trùng.
- Khi có interrupt cuộc gọi, mất audio focus, nền ứng dụng hoặc khóa màn hình, **pause và chờ người dùng resume**. Không chơi background ở MVP.
- Nếu media online không tải được: giữ player paused và cung cấp Retry/Back; không đếm giờ khi media không có.
- Khi người dùng exit sớm, lưu `abandoned`/`interrupted`, không cộng như completed. Có xác nhận trước thoát trừ tình huống cần dừng khẩn cấp.
- Player có nút `Dừng` dễ nhìn, caption và an toàn; demo placeholder không bao giờ mô tả là clip hướng dẫn đúng động tác.

### 6. Offline downloads

- Bundled starter pack đủ tối thiểu cho một bài demo/khởi động ngắn offline. Nếu video thật chưa có: hiển thị nội dung demo, tuyệt đối không xuất bản dưới dạng hướng dẫn tập.
- Download routine pack: manifest version, đường dẫn, SHA-256, size; tải vào temp, validate, đổi sang ready atomically, lưu DB; retry/cancel; giữ phiên bản cũ nếu download mới hỏng.
- Báo thiếu storage, lỗi mạng, file corrupt, không có media; không nhầm cache tạm với file offline lâu dài.
- Khi bật airplane mode, một pack đã sẵn sàng phải phát đầy đủ. Tiến độ học/tập không mất sau restart.
- Mở app khi mạng yếu không ảnh hưởng Home/Library đã lưu cục bộ.

### 7. Screens và hành vi cụ thể

Triển khai S01–S12 theo PRD và wireframe:
- Onboarding: lợi ích và cảnh báo wellness; mục tiêu và tư thế là tùy chọn; không thu thập y tế.
- Home: chỉ một CTA nổi bật `Bắt đầu`, card bài đề xuất, truy cập thư viện và tiến độ.
- Library: filter theo mục tiêu, thời lượng, đứng/ngồi, offline; dữ liệu demo phân biệt rõ.
- Detail: video/poster, mục đích, danh sách steps, nhãn downloaded, CTA download/start; không dẫn vào player lỗi.
- Preflight: checklist nhẹ và xác nhận đã đọc cảnh báo trước phiên.
- Player: media lớn, timers, caption/voice, next/prev/pause/exit, nút dừng rõ.
- Pause/Exit: resume, kết thúc sớm, xác nhận tác động đến lịch sử.
- Summary: phút thực tập và trạng thái thực (không thổi phồng hoàn thành).
- Progress: lịch sử local, trạng thái incomplete vs completed rõ.
- Settings: nhạc/giọng/caption, reduced motion, reminder, quyền thông báo, quyền riêng tư.
- Downloads: trạng thái và dung lượng, thao tác tải/xóa.
- Safety/help: nguyên tắc chung, nút trở lại bài, không đưa chẩn đoán.

### 8. Test bắt buộc và acceptance

Viết unit tests cho model validation, aggregate durations, monotonic clock, pause/resume/buffer lifecycle, session completion semantics, download hash verification, settings persistence và migration. Viết widget tests cho core screens, semantics, font scaling. Viết integration/e2e test của happy path offline, dismiss/resume, phone/audio focus simulation nơi phù hợp, file corrupt, interruption và restart. Dùng fake clocks/media adapters để test ổn định; không delay/sleep ngẫu nhiên.

**Release gate:** chỉ chấp nhận production khi `flutter analyze` sạch, unit/widget test pass, bài offline chạy end-to-end trên Android và iOS thật, audio/video không bị lệch nghiêm trọng, không có placeholder media đóng vai asset đã duyệt, 100% động tác/clip được chuyên gia phù hợp kiểm duyệt và ghi lại người duyệt/ngày duyệt.

### 9. Hình thức báo cáo kết quả

Khi hoàn thành mỗi milestone, báo cáo ngắn:
1. Đã implement thật những màn/tính năng nào; có ảnh chụp màn nếu test device/emulator sẵn.
2. Các lệnh đã chạy và kết quả thật, không đoán.
3. Những feature chỉ demo và lý do chặn production.
4. Các rủi ro media/offline/audio focus hiện tại.
5. Việc kế tiếp theo độ ưu tiên và file cần bàn giao.

Bắt đầu bằng việc **đọc tài liệu và repo**, tạo `IMPLEMENTATION_PLAN.md`, rồi triển khai vertical slice hoàn chỉnh. Không dừng lại ở đề xuất kiến trúc chung hoặc một loạt màn hình rỗng.

---

## Điều kiện bàn giao kỳ vọng từ agent

- Repository Flutter chạy được trên Android/iOS (hoặc ghi rõ target chưa có SDK/device để verify).
- Tài liệu README/setup, `IMPLEMENTATION_PLAN.md`, `DECISIONS.md`.
- Test chứng minh session timer/state/media lifecycle hoạt động, không dùng `Future.delayed` để giả bộ đồng bộ playback.
- Manifest nội dung version hóa và JSON schema, content repository CMS-ready, asset series E01–E07/30 frames, hướng dẫn thêm bài không sửa UI code, checklist chuyên gia duyệt trước phát hành.
- Khẳng định minh bạch về những gì chưa có (video thực, voice thực, bản quyền, duyệt nội dung).
