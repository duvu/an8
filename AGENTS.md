# AGENTS.md — Quy tắc bắt buộc cho mọi AI coding agent

Áp dụng bắt buộc cho mọi AI coding agent, mọi thay đổi trong workspace này.

**Ưu tiên khi xung đột:** Correctness → Safety → Maintainability → Simplicity → Performance.

## 1. Workflow bắt buộc (mỗi task)

1. **Trước khi code:** đọc `TRACKER.md` (task, dependency, acceptance criteria), `PRINCIPLES.md`, các mục liên quan trong `LEARNINGS.md`, và phần PRD/spec liên quan (`01_`…`05_`).
2. **Trong khi code:** chỉ làm phạm vi task; không triển khai chức năng tương lai (YAGNI).
3. **Sau khi code:** chạy kiểm tra (xem §3), cập nhật `TRACKER.md`; ghi lỗi quan trọng vào `LEARNINGS.md`; nâng bài học tổng quát thành nguyên tắc trong `PRINCIPLES.md`.
4. **Báo cáo:** kết quả thực tế (lệnh đã chạy + output tóm tắt), phần chưa làm, rủi ro. Không tuyên bố DONE khi chưa verify.

## 2. Tiêu chuẩn kỹ thuật

- **SOLID, DRY, KISS, YAGNI:** code đơn giản, tái sử dụng hợp lý, không over-engineering.
- **Clean Architecture & DDD:** feature-first, high cohesion, low coupling, separation of concerns, dependency injection (Riverpod providers).
- **Flutter:** MVVM + Riverpod; widget chỉ render state; business logic trong Notifier/ViewModel/domain; state bất biến; component-driven; quản lý lifecycle (dispose, app lifecycle, audio focus) và performance.
- **Backend & API (khi có):** API-first, contract-driven, modular monolith, validation, security, idempotency, observability. MVP hiện **không** có backend.
- **Database & Storage:** schema-first, migrations có version, transactions, data integrity, offline-first.
- **Content:** Exercise, Routine, MediaAsset độc lập; data-driven qua catalog có schema/version; CMS-ready nhưng **không xây CMS**.
- **Design System:** token 3 lớp Primitive → Semantic → Component, dùng chung mobile/web; không hardcode màu/spacing/typography trong widget; accessibility (≥48dp, contrast ≥4.5:1, text scale 200%, semantics tiếng Việt) và responsive.
- **Code Quality:** strong typing, tên rõ nghĩa, xử lý lỗi tường minh, tối thiểu dependency, unit/widget/integration tests, regression test cho mỗi bug đã sửa.

## 3. Kiểm tra (verify gate)

| Phạm vi thay đổi | Lệnh bắt buộc |
|---|---|
| Catalog / assets / scripts | `python scripts/validate_catalog.py` (cần `jsonschema`, `pillow`) |
| Flutter code | `flutter pub get` · `dart format --set-exit-if-changed lib test` · `flutter analyze` · `flutter test` |

Nếu môi trường không chạy được một bước, ghi rõ trong báo cáo và trong `TRACKER.md`; task không được đánh DONE.

## 4. Tài liệu duy trì

- `TRACKER.md` — nguồn duy nhất cho backlog, ưu tiên, dependency, tiến độ, acceptance criteria (thay cho `IMPLEMENTATION_PLAN.md` nêu trong `02_Claude_Code_Flutter_Prompt.md`).
- `LEARNINGS.md` — Detect → Root Cause → Fix → Prevent → Verify → Record.
- `PRINCIPLES.md` — nguyên tắc bắt buộc, kiểm chứng được.

**Quy tắc cuối:** không chỉ hoàn thành task — bảo vệ kiến trúc, duy trì tiến độ, ngăn sai lầm tái diễn.
