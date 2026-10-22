# 06 — Media cần bổ sung & prompt sản xuất

**Ngày:** 18/10/2026 · **Dùng cho:** đội sản xuất nội dung / AI agent tạo media · **Nguồn số liệu:** `catalog/catalog.v1.json`, `packages/an_nhien_eastern_content/assets/catalog/*`, `An_Nhien_Eastern_Content_DropIn_v0.1/media_plans/*`.

App đã chạy được nhưng phần lớn media còn thiếu hoặc chỉ là ảnh minh họa:

- **E01–E07:** đang dùng ảnh AI (chủ sản phẩm duyệt dùng chính thức, `DECISIONS.md` D08). Còn sai lệch đã biết và chưa có video/giọng đọc.
- **60 thức phương Đông (E101–E524):** mới có thẻ tên trang trí; app chỉ hiện dạng giới thiệu (D09). Muốn tập được thì mỗi thức cần tư thế, video và phụ đề.
- **App:** icon vẫn là icon mặc định của Flutter; Player chưa có âm báo đổi động tác.

---

## 1. Prompt chính (copy dán cho đội sản xuất hoặc AI agent)

> **Dùng ChatGPT để tạo ảnh từng thức, giọng đọc, âm báo và nhạc nền:** xem `07_ChatGPT_Media_Prompts.md`. File đó có prompt khởi tạo phiên, prompt nhân vật, prompt từng ảnh (3 khung/thức, kèm bản vịn ghế), kịch bản giọng đọc theo mốc thời gian, mô tả âm báo và nhạc nền. Prompt dưới đây dành cho đội sản xuất người thật.

```text
Bạn là đội sản xuất media cho "An Nhiên" — ứng dụng dưỡng sinh nhẹ nhàng, tiếng Việt,
cho người trung niên và lớn tuổi, tập tại nhà hoặc ngoài trời (đặt điện thoại cách 1–2 m).

NHIỆM VỤ
Tạo media hướng dẫn cho các động tác trong danh sách đính kèm (file 06_Media_Production_Brief.md,
mục 3). Mỗi dòng có mã (E01…E524), tên, tư thế, thời lượng và ghi chú an toàn. Làm theo đúng
đường dẫn file, kích thước và định dạng ở mục 2.

NGUYÊN TẮC NỘI DUNG (bắt buộc)
1. Mục đích là hướng dẫn tư thế đúng, không phải ảnh trang trí. Toàn thân luôn nằm trọn trong
   khung (không cắt đầu, tay, chân), đặt giữa, chừa lề 6–8%.
2. Chuyển động chậm, biên độ vừa phải, trong phạm vi thoải mái của người lớn tuổi.
   Không nín thở, không gồng, không bẻ/giật/xoay cổ mạnh, không ấn vùng cổ trước.
3. Với động tác có ghi chú "nguy cơ ngã" hoặc "biến thể": làm thêm phiên bản vịn ghế hoặc
   ngồi ghế, và ghi rõ trong tên file (…_chair).
4. Một người hướng dẫn xuyên suốt cho mỗi hệ: cùng gương mặt, trang phục, bối cảnh,
   ánh sáng và góc máy giữa các khung, để người xem thấy rõ cái thay đổi là tư thế.
5. Ngôn ngữ lời dẫn: tiếng Việt, câu ngắn 1–2 dòng, giọng ấm, chậm, không hô hào.
   Không hứa hẹn chữa bệnh, không nói về triệu chứng.
6. Với các hệ phương Đông: tên thức, thứ tự và kỹ thuật phải theo một trường phái/nguồn cụ thể
   do chuyên gia chọn. Ghi tên trường phái và người đối chiếu vào hồ sơ bàn giao.
   Không tự suy diễn kỹ thuật từ tên thức.
7. Mọi media có hồ sơ: người tạo/quay, công cụ (nếu là AI thì ghi rõ), quyền sử dụng thương mại,
   người duyệt chuyên môn, ngày duyệt.

PHONG CÁCH HÌNH ẢNH
- Bảng màu An Nhiên: xanh teal đậm #073F3B / #0A5249, nền kem #FAF9F3, điểm nhấn bạc hà #7FD1BC.
- Bối cảnh tối giản, sáng dịu, không chữ trong ảnh tư thế (chữ do app hiển thị).
- Trang phục gọn, màu trơn tương phản với nền để thấy rõ đường tay chân.
- Người hướng dẫn 50–65 tuổi, dáng khỏe tự nhiên.
- **Style lock:** trước mỗi lần sinh ảnh phải đính kèm asset đang dùng trong app của đúng series làm reference. Ảnh mới phải giữ cùng danh tính, phục trang, bối cảnh, ánh sáng, góc máy và mức độ chân thực; không chấp nhận mô tả chữ đơn thuần hoặc một nhân vật “gần giống”. Với Thái Cực 24, reference chuẩn là `E501_cover.webp`, `E503_cover.webp`, `E501/04_step_1.webp`, `E503/04_step_1.webp`: nam áo teal, quần đen, giày trắng, studio kem.

BÀN GIAO
Đúng cây thư mục ở mục 2. Mỗi file kèm một dòng trong `media_manifest.csv`:
path, exercise_id, slot, width, height, duration_s, creator, tool, ai_generated (yes/no),
license, reviewer, review_date, notes.
```

### 1.1 Mẫu prompt sinh ảnh tư thế (cho công cụ AI ảnh, tiếng Anh)

Dùng cho từng khung trong mục 3. Thay phần trong `{…}`. Ảnh AI **chỉ dùng làm bản phác thảo** cho tới khi chuyên gia đối chiếu tư thế (với các hệ phương Đông, gói nội dung phương Đông yêu cầu media người thật).

```text
Instructional exercise photo, square 1:1, full body fully in frame with margin,
{age 55-65} {gender} instructor, plain {teal} short-sleeve top and dark trousers,
{standing | seated on a sturdy wooden chair}, {exact pose description from the expert},
{front | 3/4} view, eye-level camera, soft even daylight, minimal cream background (#FAF9F3)
with one small plant, calm neutral expression, realistic proportions, no text, no watermark,
no motion blur, consistent character with previous frames of this series.
Negative: cropped limbs, extra fingers, distorted joints, exaggerated range of motion,
dramatic lighting, fantasy scenery, text, logo.
```

### 1.2 Mẫu kịch bản lời dẫn và phụ đề

```text
[E01 · Thở tự nhiên · 2:00]
00:00  Ngồi vững trên ghế, vai và hàm thả lỏng.
00:30  Đặt tay lên bụng nếu thấy dễ chịu.
01:00  Hít thở nhẹ theo nhịp tự nhiên.
01:30  Tiếp tục thở đều, không nín thở.
(Quy tắc: mỗi câu ≤ 2 dòng × 32 ký tự; câu khớp đúng mốc chuyển khung ảnh trong app:
 khung ảnh chia đều thời lượng bước.)
```

---

## 2. Quy chuẩn kỹ thuật

| Loại | Kích thước / định dạng | Ghi chú |
|---|---|---|
| Khung tư thế (pose frame) | 1080×1080 (nhận 1024×1024 từ ChatGPT), WebP q85 (≤150 KB) hoặc PNG | Vuông: app hiển thị 1:1 (Player, chế độ xem từ xa) |
| Ảnh thumbnail / bìa | 1080×1440 (3:4), WebP; thumbnail 540×720 | Bìa có thể có chữ; ảnh tư thế thì không |
| Video hướng dẫn | MP4 H.264, 1920×1080 16:9, 30 fps, ≤ 8 Mbps; AAC 48 kHz | **Giọng đọc ghép sẵn trong video** (PRD §8.3: ít lệch tiếng nhất). Toàn thân luôn trong khung |
| Phụ đề | WebVTT `vi`, UTF-8 | Mốc thời gian khớp video |
| Giọng đọc rời (tùy chọn) | AAC/M4A 48 kHz mono, −16 LUFS | Chỉ khi không ghép vào video |
| Âm báo | OGG + M4A, 48 kHz, ≤ 1.0 s, −18 LUFS | Dịu, không chói; nghe rõ cách 2 m ngoài trời |
| Nhạc nền | OGG + M4A, 48 kHz stereo, vòng lặp 2–3 phút, −23 LUFS | Không lời; 6 bản theo hệ/buổi (chi tiết ở file 07, mục 6) |

**Đường dẫn:**

- E01–E07: `assets/series/E0x/frames/NN.png` (giữ tên; `scripts/build_series_assets.py` dựng lại storyboard/thumbnail), video `assets/media/E0x/guide.mp4`, phụ đề `assets/media/E0x/guide.vi.vtt`.
- Phương Đông: `packages/an_nhien_eastern_content/assets/series/E101/pose_start.webp`, `pose_transition.webp`, `pose_end.webp`, `guide.mp4`, `guide.vi.vtt`; biến thể ghế thêm hậu tố `_chair`. Điền đường dẫn vào `An_Nhien_Eastern_Content_DropIn_v0.1/media_plans/<hệ>/<mã>/series.plan.v1.json` (các khe `frames[].assetPath`, `videoPath`, `subtitlePath`, `voicePath`, `contentSafetyReviewer`, `licenseVerified`).
- Âm báo: `assets/audio/cues/<tên>.ogg|.m4a`.

---

## 3. Danh sách chi tiết

### 3.1 App (P0)

| # | Media | Đặc tả | Số file |
|---|---|---|---:|
| A1 | Icon ứng dụng | Master 1024×1024 PNG; Android adaptive: foreground 432×432 (vùng an toàn 264) + nền màu #073F3B; iOS 1024×1024 không trong suốt. Biểu tượng tối giản (hoa sen/lá + hơi thở), đọc được ở 48 px | 3 |
| A2 | Âm "chuẩn bị đổi động tác" | Phát lúc còn 10 s (khớp cảnh báo hổ phách ở chế độ xem từ xa) | 1 |
| A3 | Âm "bắt đầu động tác mới" | Phát ngay khi sang bước mới | 1 |
| A4 | Âm đếm ngược 3-2-1 | 1 tiếng ngắn, phát 3 lần | 1 |
| A5 | Âm hoàn thành bài | Dịu, ≤ 1.5 s | 1 |

### 3.2 Bộ cơ bản E01–E07 (P0: sửa sai lệch; P1: video)

**Phải sửa ngay:**

- **E04 khung 03** ("Giữ cổ và vai thả lỏng"): ảnh hiện giơ tay quá đầu, mâu thuẫn ghi chú "Không cần nâng quá đầu". Làm lại với tay nâng tới ngang vai hoặc thấp hơn.
- **E06** (Đi bộ tại chỗ): README cũ đã ghi là có thể sai tư thế. Làm lại có ghế/chỗ vịn trong khung, gối nâng thấp.
- Bộ ảnh hiện là 680×680. Nên làm lại cả 30 khung ở 1080×1080 cho chế độ xem từ xa.

| Mã | Động tác | Tư thế | Thời lượng | Khung | Lời dẫn từng khung (= phụ đề) | Ghi chú an toàn |
|---|---|---|---:|---:|---|---|
| E01 | Thở tự nhiên | Ngồi | 2:00 | 4 | 01. Ngồi vững, vai và hàm thả lỏng.<br>02. Đặt tay lên bụng nếu thấy dễ chịu.<br>03. Hít thở nhẹ theo nhịp tự nhiên.<br>04. Tiếp tục thở đều, không nín thở. | Không cố hít quá sâu hoặc nín thở. |
| E02 | Xoay vai nhẹ | Đứng | 2:00 | 4 | 01. Đứng hoặc ngồi thẳng, thả lỏng vai.<br>02. Nhẹ nhàng nâng và đưa vai ra sau.<br>03. Tiếp tục vòng xoay nhỏ, chậm.<br>04. Hạ vai, thở đều, đổi chiều. | Không xoay mạnh cổ hay giật vai. |
| E03 | Bàn tay và cổ chân | Ngồi | 2:00 | 6 | 01. Duỗi nhẹ các ngón tay.<br>02. Nắm tay vừa phải, không siết chặt.<br>03. Mở bàn tay và thả lỏng.<br>04. Ngồi vững, nhấc gót chân.<br>05. Đổi sang nhấc mũi chân.<br>06. Xoay cổ chân nhỏ nếu thoải mái. | Ngừng nếu xuất hiện đau hoặc tê tăng. |
| E04 | Nâng hạ hai tay | Đứng | 2:00 | 4 | 01. Đứng vững, tay thả lỏng hai bên.<br>02. Nâng tay chậm đến mức dễ chịu.<br>03. Giữ cổ và vai thả lỏng.<br>04. Hạ tay chậm, thở tự nhiên. | Không cần nâng quá đầu; tránh gồng vai. |
| E05 | Chuyển trọng tâm | Đứng | 2:00 | 4 | 01. Đứng rộng bằng vai cạnh chỗ vịn.<br>02. Chuyển nhẹ trọng lượng sang trái.<br>03. Đổi từ từ sang bên phải.<br>04. Trở về giữa, giữ nhịp thở đều. | Hai chân luôn chạm sàn; vịn ghế nếu cần. |
| E06 | Đi bộ tại chỗ | Đứng | 3:00 | 4 | 01. Đứng thẳng gần chỗ vịn.<br>02. Nhấc chân phải thấp, nhẹ nhàng.<br>03. Đổi sang chân trái và giữ thăng bằng.<br>04. Bước đều chậm, hít thở tự nhiên. | Không cần nâng gối cao; dừng nếu choáng. |
| E07 | Ngồi thư giãn | Ngồi | 1:00 | 4 | 01. Ngồi trên ghế chắc chắn, chân chạm sàn.<br>02. Giữ lưng thoải mái, thở tự nhiên.<br>03. Buông lỏng vai, hàm và bàn tay.<br>04. Ngồi yên một lúc, chú ý hơi thở. | Không ép hoặc điều khiển nhịp thở quá mức. |

Mỗi động tác E01–E07 cần thêm: **1 video hướng dẫn có giọng đọc** (dài bằng thời lượng ở trên) và **1 phụ đề `.vi.vtt`**, tổng 7 video + 7 phụ đề.

**Ảnh bìa routine (P2):** hiện app lấy thumbnail của động tác đầu tiên làm bìa. Làm bìa 3:4 riêng cho
R01 Khởi động nhẹ, R02 Dưỡng sinh sáng 14 phút, R03 Thư giãn cổ vai 8 phút, R04 Dưỡng sinh trên ghế 10 phút, R05 Thư giãn buổi tối 6 phút (5 file).

### 3.3 Dưỡng sinh phương Đông E101–E524 (P0 để mở tập; phụ thuộc T14 — chuyên gia chốt trường phái)

Mỗi thức cần:

1. 3 khung tư thế: `pose_start`, `pose_transition`, `pose_end`.
2. 1 video có giọng đọc.
3. 1 phụ đề `vi`.
4. Thêm bộ 3 khung `_chair` nếu cột "Biến thể / rủi ro" ghi vịn ghế hoặc biến thể.

Thời lượng lấy từ catalog nháp, chuyên gia có thể điều chỉnh. Cột "Biến thể / rủi ro" là **gợi ý dựa trên đặc điểm thường gặp của thức**, chuyên gia phải xác nhận.

#### Bát Đoạn Cẩm — Ba Duan Jin — Eight Brocades (8 thức, routine R101 10 phút)

_Bộ 8 thức đứng thường gặp; tên Việt là bản biên tập, cần đối chiếu với giảng viên_

| Mã | # | Tên Việt | Tên gốc | Tư thế | Thời lượng | Biến thể / rủi ro |
|---|---:|---|---|---|---:|---|
| E101 | 1 | Song thủ thác thiên | Two Hands Hold up the Heavens | Đứng | 75 s | — |
| E102 | 2 | Tả hữu khai cung | Drawing the Bow to Shoot the Hawk | Đứng | 75 s | Tấn ngựa: dùng tấn cao, có biến thể ngồi |
| E103 | 3 | Điều lý tỳ vị, nhất thủ cử | Separating Heaven and Earth | Đứng | 75 s | — |
| E104 | 4 | Ngũ lao thất thương vãng hậu tiều | Wise Owl Gazes Backwards | Đứng | 75 s | Xoay đầu nhìn sau: biên độ nhỏ, không xoay cổ mạnh |
| E105 | 5 | Dao đầu bãi vĩ | Sway the Head and Shake the Tail | Đứng | 75 s | Tấn thấp + nghiêng/cúi thân: dễ chóng mặt; biến thể ngồi |
| E106 | 6 | Lưỡng thủ phàn túc | Two Hands Hold the Feet | Đứng | 75 s | Cúi gập sâu: rủi ro huyết áp/thắt lưng; biên độ nhỏ, biến thể ngồi |
| E107 | 7 | Toản quyền nộ mục | Clench the Fists and Glare | Đứng | 75 s | — |
| E108 | 8 | Bối hậu thất điên | Bouncing on the Toes | Đứng | 75 s | Nhón gót rồi hạ: thăng bằng/khớp; vịn ghế, hạ gót nhẹ |

#### Dịch Cân Kinh — Yi Jin Jing — 12 forms (12 thức, routine R102 15 phút)

_Danh mục 12 thức tham khảo từ trường phái phổ biến, cách thực hiện tùy hệ truyền thừa_

| Mã | # | Tên Việt | Tên gốc | Tư thế | Thời lượng | Biến thể / rủi ro |
|---|---:|---|---|---|---:|---|
| E201 | 1 | Vi Đà hiến chử — thức 1 | Wei Tuo Offers the Pestle I | Đứng | 75 s | — |
| E202 | 2 | Vi Đà hiến chử — thức 2 | Wei Tuo Offers the Pestle II | Đứng | 75 s | — |
| E203 | 3 | Vi Đà hiến chử — thức 3 | Wei Tuo Offers the Pestle III | Đứng | 75 s | — |
| E204 | 4 | Trích tinh hoán đẩu | Plucking Stars and Changing the Dipper | Đứng | 75 s | — |
| E205 | 5 | Đảo duệ cửu ngưu vĩ | Pulling Nine Oxen by the Tail | Đứng | 75 s | — |
| E206 | 6 | Xuất trảo lượng sí | Showing Claws and Spreading Wings | Đứng | 75 s | — |
| E207 | 7 | Cửu quỷ bạt mã đao | Nine Ghosts Drawing Sabres | Đứng | 75 s | — |
| E208 | 8 | Tam bàn lạc địa | Three Plates Landing | Đứng | 75 s | Hạ tấn thấp: đầu gối; tấn cao |
| E209 | 9 | Thanh long thám trảo | Green Dragon Extending Claws | Đứng | 75 s | — |
| E210 | 10 | Ngọa hổ phác thực | Crouching Tiger Pounces | Đứng | 75 s | Cúi thấp, chống tay: nguy cơ ngã; biến thể vịn ghế |
| E211 | 11 | Đả cung | Bowing Posture | Đứng | 75 s | Cúi gập, tay ôm sau đầu: không kéo cổ |
| E212 | 12 | Điệu vĩ | Wagging the Tail | Đứng | 75 s | Cúi gập sâu: biên độ nhỏ |

#### Ngũ Cầm Hí — Wu Qin Xi — Five Animals (10 thức, routine R103 12,5 phút)

_5 loài vật (hổ, hươu, gấu, khỉ, chim), mỗi loài hai động tác theo bộ thường dạy_

| Mã | # | Tên Việt | Tên gốc | Tư thế | Thời lượng | Biến thể / rủi ro |
|---|---:|---|---|---|---:|---|
| E301 | 1 | Hổ giơ vuốt | Tiger Raising | Đứng | 75 s | — |
| E302 | 2 | Hổ vồ mồi | Tiger Seizing | Đứng | 75 s | Cúi người: biên độ nhỏ |
| E303 | 3 | Hươu húc gạc | Deer Colliding | Đứng | 75 s | — |
| E304 | 4 | Hươu chạy | Deer Running | Đứng | 75 s | Bước tới/lui: chỗ tập rộng, nền không trơn |
| E305 | 5 | Gấu lắc mình | Bear Swaying | Đứng | 75 s | — |
| E306 | 6 | Gấu xoa bụng | Bear Rubbing | Đứng | 75 s | — |
| E307 | 7 | Khỉ cảnh giác | Monkey Alert | Đứng | 75 s | — |
| E308 | 8 | Khỉ hái quả | Monkey Plucking | Đứng | 75 s | — |
| E309 | 9 | Chim vươn cánh | Bird Stretching | Đứng | 75 s | Đứng một chân: vịn ghế |
| E310 | 10 | Chim bay | Bird Flying | Đứng | 75 s | Đứng một chân: vịn ghế |

#### Lục Tự Quyết — Liu Zi Jue — Six Sounds (6 thức, routine R104 7,5 phút)

_Chỉ có metadata âm tiết; không có audio phát âm hoặc kỹ thuật hơi thở đã thẩm định_

| Mã | # | Tên Việt | Tên gốc | Tư thế | Thời lượng | Biến thể / rủi ro |
|---|---:|---|---|---|---:|---|
| E401 | 1 | Âm Xu (嘘) | Xu / xū | Đứng/ngồi | 75 s | Phát âm kéo dài: không nín thở; cần audio chuẩn |
| E402 | 2 | Âm He (呵) | He / hē | Đứng/ngồi | 75 s | Như E401 |
| E403 | 3 | Âm Hu (呼) | Hu / hū | Đứng/ngồi | 75 s | Như E401 |
| E404 | 4 | Âm Si (呬) | Si / sī | Đứng/ngồi | 75 s | Như E401 |
| E405 | 5 | Âm Chui (吹) | Chui / chuī | Đứng/ngồi | 75 s | Như E401 |
| E406 | 6 | Âm Xi (嘻) | Xi / xī | Đứng/ngồi | 75 s | Như E401 |

**Bổ sung riêng Lục Tự Quyết:** 6 file **audio phát âm chuẩn** từng âm (Xu, He, Hu, Si, Chui, Xi), mỗi file một lần đọc mẫu chậm và một lần kèm nhịp thở ra; người phát âm do chuyên gia chỉ định.

#### Thái Cực Quyền 24 thức — Simplified Taijiquan 24 Forms (24 thức, routine R105 22 phút)

_Thái Cực giản hóa 24 thức; tư thế khó cần biên tập biến thể và huấn luyện chuyên môn_

| Mã | # | Tên Việt | Tên gốc | Tư thế | Thời lượng | Biến thể / rủi ro |
|---|---:|---|---|---|---:|---|
| E501 | 1 | Khởi thế | Commencing Form | Đứng | 55 s | — |
| E502 | 2 | Dã mã phân tông | Part the Wild Horse’s Mane | Đứng | 55 s | — |
| E503 | 3 | Bạch hạc lượng sí | White Crane Spreads its Wings | Đứng | 55 s | Hư bộ (trụ một chân chính): vịn ghế |
| E504 | 4 | Lâu tất ảo bộ | Brush Knee and Push Forward | Đứng | 55 s | — |
| E505 | 5 | Thủ huy tỳ bà | Playing the Lute | Đứng | 55 s | — |
| E506 | 6 | Đảo quyển quăng | Repulse Monkey | Đứng | 55 s | — |
| E507 | 7 | Tả lãm tước vĩ | Grasp Sparrow’s Tail Left | Đứng | 55 s | — |
| E508 | 8 | Hữu lãm tước vĩ | Grasp Sparrow’s Tail Right | Đứng | 55 s | — |
| E509 | 9 | Đơn tiên | Single Whip | Đứng | 55 s | — |
| E510 | 10 | Vân thủ | Cloud Hands | Đứng | 55 s | — |
| E511 | 11 | Đơn tiên (lặp) | Single Whip | Đứng | 55 s | — |
| E512 | 12 | Cao thám mã | High Pat on Horse | Đứng | 55 s | — |
| E513 | 13 | Hữu đăng cước | Right Heel Kick | Đứng | 55 s | Đá gót, đứng một chân: nguy cơ ngã cao; biến thể không đá |
| E514 | 14 | Song phong quán nhĩ | Strike to the Ears with Both Fists | Đứng | 55 s | — |
| E515 | 15 | Chuyển thân tả đăng cước | Turn and Left Heel Kick | Đứng | 55 s | Xoay người + đá gót: nguy cơ ngã cao; biến thể |
| E516 | 16 | Tả hạ thế độc lập | Left Lower Body and Stand on One Leg | Đứng | 55 s | Hạ thế thấp + đứng một chân: nguy cơ ngã rất cao; biến thể bắt buộc |
| E517 | 17 | Hữu hạ thế độc lập | Right Lower Body and Stand on One Leg | Đứng | 55 s | Như E516 |
| E518 | 18 | Tả hữu xuyên thoa | Fair Lady Works the Shuttles | Đứng | 55 s | — |
| E519 | 19 | Hải để châm | Needle at Sea Bottom | Đứng | 55 s | Cúi người: biên độ nhỏ |
| E520 | 20 | Thiểm thông tý | Fan Through the Back | Đứng | 55 s | — |
| E521 | 21 | Chuyển thân ban lan chùy | Turn, Deflect, Parry and Punch | Đứng | 55 s | — |
| E522 | 22 | Như phong tự bế | Apparent Closing a Door | Đứng | 55 s | — |
| E523 | 23 | Thập tự thủ | Cross Hands | Đứng | 55 s | — |
| E524 | 24 | Thu thế | Closing Form | Đứng | 55 s | — |

**Tẩy Tủy Kinh:** **không tạo media** cho tới khi xong nghiên cứu nguồn (T17). Hiện chỉ có ảnh bìa.

---

## 4. Tổng hợp số lượng

| Nhóm | Ảnh | Video | Phụ đề | Audio | Ưu tiên |
|---|---:|---:|---:|---:|---|
| App (icon + âm báo) | 3 | — | — | 4 | P0 |
| E01–E07 làm lại khung | 30 | — | — | — | P0 (E04-03, E06), P1 phần còn lại |
| E01–E07 video + phụ đề | — | 7 | 7 | — | P1 |
| Bìa routine R01–R05 | 5 | — | — | — | P2 |
| Phương Đông: khung tư thế (60 × 3) | 180 | — | — | — | P0 sau T14 |
| Phương Đông: biến thể ghế (12 thức có ghi chú vịn ghế/biến thể × 3) | 36 | — | — | — | P0 sau T14 |
| Phương Đông: video + phụ đề | — | 60 | 60 | — | P0 sau T14 |
| Lục Tự Quyết: phát âm | — | — | — | 6 | P0 sau T14 |
| Nhạc nền (M1–M6) | — | — | — | 6 | P1 |
| **Tổng** | **254** | **67** | **67** | **16** | |

---

## 5. Quy trình nhận và tích hợp

1. **Đối chiếu chuyên môn trước khi sản xuất:** chuyên gia chốt trường phái, tên thức và kỹ thuật (T14). Bàn giao kịch bản tư thế cho từng thức.
2. **Sản xuất** theo mục 1–3, bàn giao kèm `media_manifest.csv`.
3. **Duyệt từng file** theo checklist PRD §9.2: tư thế, tốc độ, số lần lặp, lời dẫn, cảnh báo, phương án ngồi, phụ đề. Thêm kiểm tra toàn thân trong khung và bản quyền.
4. **Đưa vào repo:**
   - E01–E07: thay `assets/series/E0x/frames/`, chạy `python scripts/build_series_assets.py && python scripts/generate_catalog.py && python scripts/validate_catalog.py`.
   - Phương Đông: thêm file vào `packages/an_nhien_eastern_content/assets/series/…`, khai báo lại thư mục trong `pubspec.yaml` của gói, cập nhật `mediaAssets` (bytes, sha256, rights, reviewer) và `media_plans`, rồi chạy `python -I An_Nhien_Eastern_Content_DropIn_v0.1/scripts/validate_content.py`.
5. **App:** video và audio cần làm T06 (adapter video/audio, âm báo). Phát hành bài phương Đông cần T16 (đưa vào catalog chính, cổng xuất bản P03).
6. **Xác minh:** `flutter analyze`, `flutter test`, chạy thử trên thiết bị thật ở chế độ thường và chế độ xem từ xa (cách 2 m, buổi tối).

**Không nhận** media: cắt mất tay/chân/đầu; có chữ hay watermark trong ảnh tư thế; biên độ quá mức; thiếu hồ sơ quyền sử dụng; hoặc chưa có người duyệt chuyên môn (với nội dung phương Đông).
