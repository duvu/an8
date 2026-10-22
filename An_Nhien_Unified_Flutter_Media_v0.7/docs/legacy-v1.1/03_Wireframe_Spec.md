# WIREFRAME & APP FLOW — AN NHIÊN (FLUTTER)

**Version:** 1.1 · **Mục đích:** bàn giao UI/UX cho đội Flutter và làm checklist nghiệm thu màn hình.

## 1. Nguyên tắc tương tác
- Không quá 3 thao tác từ Home đến khi bắt đầu countdown cho một bài đã tải.
- Ở player, ảnh/video chiếm vùng lớn nhất; tên bài, step, thời gian, caption và nút Dừng phải luôn dễ thấy.
- Một hành động chính mỗi màn, dùng từ ngữ tiếng Việt đơn giản. Không dùng hiệu ứng nhấp nháy.
- Thanh điều hướng dưới cùng chỉ xuất hiện ở màn duyệt (Home, Thư viện, Tiến độ, Cài đặt), không xuất hiện khi đang tập.
- Hạn chế xin quyền trên onboarding; chỉ hỏi quyền thông báo đúng lúc bật reminder.
- Nút back trong player hỏi xác nhận nếu sắp mất phiên, nhưng nút 'Dừng ngay' phải dừng media tức thời.
- Các mockup HTML là **prototype điều hướng**, không phải app Flutter, không kèm video/hình động hướng dẫn y khoa thật.

## 2. Sitemap

```
Onboarding
  ├─ Value proposition & safety
  └─ Preference (optional) ──────────┐
                                     ↓
Bottom navigation ───────────────── HOME
  ├─ Library → Routine Detail → Preflight → Session Player
  │                                         ├─ Pause / Resume / Exit sheet
  │                                         └─ Summary → Home / Progress
  ├─ Progress → Session history
  └─ Settings → Reminders / Safety / Downloads

Home → Suggested Routine → Routine Detail
```

## 3. Wireframe text — các màn cốt lõi

### S02 Home
```
┌─────────────────────────────────┐
│ AN NHIÊN             ○ Cài đặt  │
│ Chào buổi sáng                 │
│ Hôm nay mình tập nhẹ nhé       │
│ ┌─────────────────────────────┐ │
│ │     [poster bài tập]       │ │
│ │ DƯỠNG SINH SÁNG · 14 PHÚT │ │
│ │ Nhẹ nhàng · Đứng + ngồi    │ │
│ │ [     BẮT ĐẦU     →     ] │ │
│ └─────────────────────────────┘ │
│ Bài khác                        │
│ [ Trên ghế 10' ] [ Tối 6' ]   │
│                                 │
│ ⌂ Hôm nay   ▦ Bài tập   ◷ Tiến độ│
└─────────────────────────────────┘
```

### S04 Detail + S05 Preflight
```
┌─────────────────────────────────┐
│ ← Chi tiết bài                 │
│ [ Series poster động tác     ] │
│ Dưỡng sinh sáng                │
│ 14 phút · Nhẹ · Đứng / ngồi    │
│ Thở, vai, tay chân, thư giãn   │
│ ─────── 7 động tác ─────────── │
│ 01. Thở tự nhiên · 2 phút      │
│ 02. Xoay vai · 2 phút          │
│ ...                             │
│ ⚠ Dừng nếu chóng mặt, đau ngực │
│ [       BẮT ĐẦU BÀI TẬP     ] │
└─────────────────────────────────┘
```

### S06 Session Player
```
┌─────────────────────────────────┐
│ ✕ Dừng           03 / 07       │
│ ┌─────────────────────────────┐ │
│ │ VIDEO / SERIES STORYBOARD  │ │
│ │        16:9 + captions     │ │
│ └─────────────────────────────┘ │
│ Nắm mở bàn tay, cổ chân        │
│ Hướng dẫn ngắn 1–2 dòng        │
│ 01:20 còn lại     08:40 toàn bài│
│ ▰▰▰▰▰▱▱▱▱▱▱▱▱▱                 │
│     |‹    ◉ Tạm dừng   ›|      │
│ [Giọng ✓]  [Phụ đề ✓]          │
│ ⚠ Khó chịu? Dừng ngay         │
└─────────────────────────────────┘
```

### S08 Summary
```
┌─────────────────────────────────┐
│               ✓               │
│       Hoàn thành bài tập       │
│    14 phút · Dưỡng sinh sáng   │
│ Hôm nay bạn đã dành thời gian  │
│ vận động nhẹ và thư giãn.      │
│ [       VỀ TRANG CHỦ      ]   │
│ [      XEM TIẾN ĐỘ        ]   │
└─────────────────────────────────┘
```

## 4. Danh mục màn & hành động

| ID | Mục đích | CTA chính | Secondary / Error states |
|---|---|---|---|
| S01 Onboarding | Giới thiệu, chọn mục tiêu không bắt buộc | Khám phá bài tập | Bỏ qua, safety notice |
| S02 Home | Chọn bài nhanh | Bắt đầu | Media chưa tải, bài khác |
| S03 Library | Tìm/lọc | Chọn bài | Offline filter, empty state |
| S04 Detail | Xem danh sách bước | Bắt đầu hoặc Tải | Mất mạng, pack tải dở |
| S05 Preflight | Đảm bảo hiểu cảnh báo | Tôi hiểu, bắt đầu | Quay lại |
| S06 Player | Tập theo | Pause/Resume | Skip/Prev/Dừng, lỗi media |
| S07 Exit sheet | Tránh mất phiên | Tiếp tục | Kết thúc sớm |
| S08 Summary | Ghi nhận buổi tập | Về Home | Xem tiến độ |
| S09 Progress | Xem lịch sử | Xem chi tiết | Empty state |
| S10 Settings | Cá nhân hóa thiết bị | Lưu | Quyền notification bị từ chối |
| S11 Downloads | Tải bài offline | Tải/Retry | Remove, failed checksum |
| S12 Safety | Cảnh báo rõ | Quay lại | Đường dẫn hỗ trợ |

## 5. Trạng thái màn Player bắt buộc

1. `Preparing`: poster + loading, không chạy timer.
2. `Countdown`: 3–2–1, có thể dừng.
3. `Playing`: media chạy, progress theo media.
4. `Paused`: overlay lớn + Resume.
5. `Buffering`: giữ nguyên progress, có thông báo tải nội dung.
6. `Interrupted`: tự pause khi background/phone/audio focus và cần bấm tiếp tục.
7. `Error`: Retry / Bỏ qua / Quay lại, **không ghi completed**.
8. `Abandoned`: exit sớm; không gộp completed trong lịch sử.
9. `Completed`: toàn bộ bước thực sự đã kết thúc; ghi lịch sử và mở summary.

## 6. UI components mapping Flutter

| Component wireframe | Flutter gợi ý |
|---|---|
| Bottom tabs | `NavigationBar` + `StatefulShellRoute` |
| Routine card | `InkWell` + `Card` custom semantic |
| Video surface | `AspectRatio` + `VideoPlayer` |
| Animation surface | Rive widget, chỉ với file .riv đã duyệt |
| Primary CTA | `FilledButton` / custom AppButton |
| Section list | `ListView.separated` |
| Snack / errors | `SnackBar`, error state panel |
| Exit confirmation | `showModalBottomSheet` |
| Timeline progress | `LinearProgressIndicator` + accessible label |
| Preferences/reminders | `SwitchListTile`, `TimePicker` |

## 7. UX copy và an toàn

Các microcopy ví dụ:
- Home: “Hôm nay mình tập nhẹ nhé.”
- Preflight: “Chọn vị trí đủ rộng; chuẩn bị ghế chắc nếu cần. Tập trong phạm vi thoải mái.”
- Stop: “Dừng nếu chóng mặt, đau ngực, khó thở hoặc tê/yếu mới xuất hiện hay tăng lên.”
- Draft content: “Bản xem trước — chưa phải hướng dẫn tập chính thức.”
- Offline: “Bài này chưa tải về máy. Tải trước khi tập khi không có mạng.”
- Exit: “Kết thúc sớm? Thời gian đã tập sẽ được lưu với trạng thái chưa hoàn thành.”

## 8. Design tokens đề xuất để Flutter team triển khai

- Layout: page horizontal padding 20–24dp; spacing scale 4/8/12/16/24/32; radius 12/16/24dp.
- Text: headline 26sp, title 20sp, body 16–18sp, auxiliary 14sp và hỗ trợ text scaling.
- Media: 16:9, contain, tránh crop cơ thể/hướng dẫn.
- Button: min-height 52dp; icon control min tap 48dp.
- Light theme nhã, tương phản cao; semantic tokens từ PRD, không hard-code giá trị trong widget. Mọi ý nghĩa trạng thái có text/icon, không chỉ màu.
- Đối với người cao tuổi: giảm density, lựa chọn chữ lớn, không đổi màn đột ngột, không chạy animation trang trí vô hạn.

## 9. Những giới hạn của wireframe HTML

Prototype HTML tương tác minh họa navigation và chức năng controls. Hình nhân vật/video là **placeholder**, không phải motion capture hoặc nội dung đã được kiểm duyệt. Đồng hồ demo không thay thế engine playback thực tế. Khi code Flutter, phải thực hiện các acceptance criteria ở PRD thay vì copy logic mô phỏng.


## 8. Bộ ảnh series dùng trong prototype / Flutter

- Library và Detail hiển thị thumbnail/series storyboard theo metadata từ catalog, không hardcode `E01.png` trong widget.
- Ở Detail, danh sách `RoutineStep` hiển thị ảnh thumbnail từng động tác, tên, duration; chạm để xem series theo thứ tự frame.
- Ở Player, nếu có media thực đã duyệt thì phát video/Rive; ảnh AI series chỉ được xem trong **dev-preview mode** kèm banner DRAFT. Không dùng ảnh như bản thay thế video y khoa đã duyệt.
- Chuỗi R02 theo manifest: E01 (2p) → E02 (2p) → E03 (2p) → E04 (2p) → E05 (2p) → E06 (3p) → E07 (1p).
- Content catalog Git-managed trong MVP, không CMS; UI cần sẵn khả năng render bài động được bổ sung từ `ContentCatalogRepository`.
- Theme mới: deep teal + kem và chữ tương phản, đọc rõ cho nhóm trung niên/lớn tuổi.
- Asset paths, frame/storyboard, review gates: xem `05_Content_Catalog_And_Series.md`.
