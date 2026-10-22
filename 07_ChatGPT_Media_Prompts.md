# 07 — Prompt ChatGPT: ảnh chi tiết từng thức, giọng đọc, âm báo, nhạc nền

**Ngày:** 18/10/2026 · **Đi kèm:** `06_Media_Production_Brief.md` (quy chuẩn kỹ thuật, đường dẫn, số lượng, quy trình duyệt).

> **Quan trọng:**
> - Mô tả tư thế phương Đông dưới đây là **bản tham khảo để sinh ảnh**, viết theo các phiên bản phổ biến (Health Qigong, Thái Cực giản hóa 24 thức) ở **biên độ nhẹ cho người lớn tuổi**.
> - Chuyên gia phải duyệt trước khi dùng thật (TRACKER T14).
> - Ảnh AI có thể sai khớp tay, chân hoặc biên độ: kiểm tra từng ảnh.

---

## 0. Cách dùng với ChatGPT

1. **Mỗi hệ một cuộc trò chuyện riêng** (E01–E07, Bát Đoạn Cẩm, Dịch Cân Kinh…). Như vậy nhân vật và bối cảnh giữ nhất quán.
2. Dán **Prompt khởi tạo phiên** (mục 1), rồi **Prompt tạo nhân vật** (mục 2).
3. Khi đã có ảnh nhân vật ưng ý: tải về và **đính kèm lại ảnh đó** mỗi khi bắt đầu một thức mới, kèm câu "giữ đúng nhân vật này".
4. Dán **từng prompt ảnh** ở mục 3, **mỗi lần một ảnh**. Kiểm tra theo checklist ở mục 7, đạt thì tải về, đổi tên đúng mã (ví dụ `E101_pose_start.png`).
5. Giọng đọc và nhạc nền:
   - ChatGPT dùng tốt để **viết, chỉnh kịch bản và mô tả âm thanh** (mục 4–6).
   - Nếu phiên ChatGPT của bạn không xuất được file âm thanh, đưa kịch bản và mô tả sang công cụ TTS tiếng Việt và công cụ tạo nhạc/âm thanh.
   - **Kiểm tra quyền dùng thương mại** của mọi công cụ.
6. Bàn giao theo `06_Media_Production_Brief.md` mục 2 và 5, kèm `media_manifest.csv`.

---

## 1. Prompt khởi tạo phiên (dán đầu mỗi cuộc trò chuyện)

```text
Bạn là họa sĩ minh họa hướng dẫn vận động cho "An Nhiên" — ứng dụng dưỡng sinh tiếng Việt
cho người trung niên và lớn tuổi. Trong cuộc trò chuyện này bạn sẽ tạo LẦN LƯỢT từng ảnh
hướng dẫn tư thế theo yêu cầu của tôi.

QUY TẮC CHO MỌI ẢNH
- Ảnh vuông 1:1 (1024×1024). Toàn thân nằm trọn trong khung, đặt giữa, chừa lề trên dưới
  khoảng 6–8%. Không cắt đầu, bàn tay, bàn chân.
- Góc máy ngang tầm ngực, chính diện hoặc chếch 3/4 như tôi chỉ định; ống kính tiêu chuẩn,
  không méo hình.
- Ánh sáng ban ngày mềm, đều, không bóng gắt. Phong cách ảnh chụp chân thực (photorealistic),
  không hoạt hình.
- Nền tối giản màu kem ấm (#FAF9F3), chậu cây xanh nhỏ ở góc, sàn gỗ sáng. Không chữ,
  không số, không logo, không watermark trong ảnh.
- Giữ ĐÚNG một nhân vật, trang phục, bối cảnh, ánh sáng và góc máy giữa các ảnh của cùng
  một thức. Chỉ tư thế thay đổi.
- Biên độ vừa phải, an toàn cho người lớn tuổi: khớp không khóa cứng, vai thả lỏng,
  nét mặt bình thản. Không nín thở, không gồng, không ngửa hay xoay cổ mạnh.
- Tay chân đúng giải phẫu: 5 ngón mỗi bàn tay, khớp gối và khuỷu đúng hướng.
- Nếu tư thế tôi mô tả không rõ, hỏi lại tôi thay vì tự suy diễn kỹ thuật.

Mỗi lần tôi gửi một prompt có mã (ví dụ "E101 – pose_start"), hãy tạo đúng 1 ảnh và ghi
kèm một dòng mô tả ngắn để tôi đối chiếu.
```

---

## 2. Prompt tạo nhân vật (ảnh tham chiếu)

### 2.1 Bộ cơ bản E01–E07 (giữ nhân vật đang dùng trong app)

Đính kèm `assets/series/E01/frames/01.png` và `assets/series/E04/frames/01.png` làm tham chiếu:

```text
Tạo ảnh tham chiếu nhân vật (character sheet) dựa đúng người trong 2 ảnh đính kèm:
nam người Việt khoảng 55 tuổi, tóc đen ngắn, dáng khỏe tự nhiên, áo thun cổ tròn
màu xanh teal đậm (#0A5249), quần dài đen, chân trần hoặc giày vải. Nền kem, cây xanh ở góc,
ghế gỗ có tay vịn. Ảnh vuông, 3 góc trong một ảnh: chính diện đứng, chếch 3/4 đứng,
ngồi trên ghế. Không chữ.
```

### 2.2 Dưỡng sinh phương Đông (khóa theo nhân vật đang dùng trong app)

Đính kèm `packages/an_nhien_eastern_content/assets/listing/E501_cover.webp`,
`packages/an_nhien_eastern_content/assets/listing/E503_cover.webp`,
`packages/an_nhien_eastern_content/assets/series/E501/04_step_1.webp` và
`packages/an_nhien_eastern_content/assets/series/E503/04_step_1.webp` làm reference pack bắt buộc:

```text
Tạo character sheet bám đúng người trong reference pack: nam người Việt 50–60 tuổi,
tóc đen ngắn, gương mặt bình thản, dáng khỏe tự nhiên; áo thun cổ tròn teal đậm
(#0A5249), quần đen rộng, giày tập trắng. Bối cảnh: studio kem ấm (#FAF9F3),
sàn gỗ sáng, cây xanh nhỏ làm mờ, ánh sáng ban ngày mềm và đều. Ảnh vuông, 3 góc:
chính diện đứng, chếch 3/4 đứng, đứng vịn lưng ghế. Giữ đúng danh tính, tỷ lệ cơ thể,
phục trang, ánh sáng và camera của reference; không tạo người “gần giống”. Không chữ.
```

---

## 3. Prompt từng ảnh

**Mẫu chung** (đã ghép sẵn cho từng ảnh bên dưới, chỉ cần copy từng khối):

```text
{MÃ} – {khe}. {Hệ} – thức {n}: {tên Việt} ({tên gốc}).
Tư thế: {mô tả}.
Góc máy: {chính diện | chếch 3/4}. Giữ đúng nhân vật và bối cảnh đã thống nhất. Ảnh vuông,
toàn thân, không chữ.
```

**Đặt tên file:** `{MÃ}_{khe}.png` (ví dụ `E101_pose_start.png`). Phiên bản ghế: `{MÃ}_{khe}_chair.png`.

**Khi đưa vào app:**
- Mỗi thức sẽ có 3 bước (`pose_start`, `pose_transition`, `pose_end`). Cột "Lời trên app" là `instruction` của từng bước trong catalog.
- Hiện catalog nháp mới có 2 bước (thẻ tên + "chờ duyệt"); cần thay khi tích hợp (TRACKER T16).

### 3.1 Bộ cơ bản E01–E07 (làm lại 30 khung, 1024×1024)

Mỗi khung khớp đúng câu hướng dẫn đang hiển thị trong app. Điểm cần sửa so với bộ hiện tại được ghi in đậm.

#### E01 · Thở tự nhiên (4 khung, 02:00)

```text
E01 – khung 01. Bộ cơ bản – Thở tự nhiên.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Ngồi vững, vai và hàm thả lỏng".
An toàn: Không cố hít quá sâu hoặc nín thở.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E01/frames/01.png`

```text
E01 – khung 02. Bộ cơ bản – Thở tự nhiên.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Đặt tay lên bụng nếu thấy dễ chịu".
An toàn: Không cố hít quá sâu hoặc nín thở.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E01/frames/02.png`

```text
E01 – khung 03. Bộ cơ bản – Thở tự nhiên.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Hít thở nhẹ theo nhịp tự nhiên".
An toàn: Không cố hít quá sâu hoặc nín thở.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E01/frames/03.png`

```text
E01 – khung 04. Bộ cơ bản – Thở tự nhiên.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Tiếp tục thở đều, không nín thở".
An toàn: Không cố hít quá sâu hoặc nín thở.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E01/frames/04.png`

#### E02 · Xoay vai nhẹ (4 khung, 02:00)

```text
E02 – khung 01. Bộ cơ bản – Xoay vai nhẹ.
Tư thế: đứng; minh họa đúng câu "Đứng hoặc ngồi thẳng, thả lỏng vai".
An toàn: Không xoay mạnh cổ hay giật vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E02/frames/01.png`

```text
E02 – khung 02. Bộ cơ bản – Xoay vai nhẹ.
Tư thế: đứng; minh họa đúng câu "Nhẹ nhàng nâng và đưa vai ra sau".
An toàn: Không xoay mạnh cổ hay giật vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E02/frames/02.png`

```text
E02 – khung 03. Bộ cơ bản – Xoay vai nhẹ.
Tư thế: đứng; minh họa đúng câu "Tiếp tục vòng xoay nhỏ, chậm".
An toàn: Không xoay mạnh cổ hay giật vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E02/frames/03.png`

```text
E02 – khung 04. Bộ cơ bản – Xoay vai nhẹ.
Tư thế: đứng; minh họa đúng câu "Hạ vai, thở đều, đổi chiều".
An toàn: Không xoay mạnh cổ hay giật vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E02/frames/04.png`

#### E03 · Bàn tay và cổ chân (6 khung, 02:00)

```text
E03 – khung 01. Bộ cơ bản – Bàn tay và cổ chân.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Duỗi nhẹ các ngón tay".
An toàn: Ngừng nếu xuất hiện đau hoặc tê tăng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E03/frames/01.png`

```text
E03 – khung 02. Bộ cơ bản – Bàn tay và cổ chân.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Nắm tay vừa phải, không siết chặt".
An toàn: Ngừng nếu xuất hiện đau hoặc tê tăng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E03/frames/02.png`

```text
E03 – khung 03. Bộ cơ bản – Bàn tay và cổ chân.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Mở bàn tay và thả lỏng".
An toàn: Ngừng nếu xuất hiện đau hoặc tê tăng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E03/frames/03.png`

```text
E03 – khung 04. Bộ cơ bản – Bàn tay và cổ chân.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Ngồi vững, nhấc gót chân".
An toàn: Ngừng nếu xuất hiện đau hoặc tê tăng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E03/frames/04.png`

```text
E03 – khung 05. Bộ cơ bản – Bàn tay và cổ chân.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Đổi sang nhấc mũi chân".
An toàn: Ngừng nếu xuất hiện đau hoặc tê tăng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E03/frames/05.png`

```text
E03 – khung 06. Bộ cơ bản – Bàn tay và cổ chân.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Xoay cổ chân nhỏ nếu thoải mái".
An toàn: Ngừng nếu xuất hiện đau hoặc tê tăng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E03/frames/06.png`

#### E04 · Nâng hạ hai tay (4 khung, 02:00)

```text
E04 – khung 01. Bộ cơ bản – Nâng hạ hai tay.
Tư thế: đứng; minh họa đúng câu "Đứng vững, tay thả lỏng hai bên".
An toàn: Không cần nâng quá đầu; tránh gồng vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E04/frames/01.png`

```text
E04 – khung 02. Bộ cơ bản – Nâng hạ hai tay.
Tư thế: đứng; minh họa đúng câu "Nâng tay chậm đến mức dễ chịu". **Tay nâng ra trước tới ngang ngực, không cao hơn vai.**
An toàn: Không cần nâng quá đầu; tránh gồng vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E04/frames/02.png`

```text
E04 – khung 03. Bộ cơ bản – Nâng hạ hai tay.
Tư thế: đứng; minh họa đúng câu "Giữ cổ và vai thả lỏng". **SỬA: hai tay ngang vai (không giơ quá đầu như bản cũ), vai thả lỏng, cổ dài tự nhiên.**
An toàn: Không cần nâng quá đầu; tránh gồng vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E04/frames/03.png`

```text
E04 – khung 04. Bộ cơ bản – Nâng hạ hai tay.
Tư thế: đứng; minh họa đúng câu "Hạ tay chậm, thở tự nhiên". Tay đang hạ chậm xuống hai bên.
An toàn: Không cần nâng quá đầu; tránh gồng vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E04/frames/04.png`

#### E05 · Chuyển trọng tâm (4 khung, 02:00)

```text
E05 – khung 01. Bộ cơ bản – Chuyển trọng tâm.
Tư thế: đứng; minh họa đúng câu "Đứng rộng bằng vai cạnh chỗ vịn".
An toàn: Hai chân luôn chạm sàn; vịn ghế nếu cần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E05/frames/01.png`

```text
E05 – khung 02. Bộ cơ bản – Chuyển trọng tâm.
Tư thế: đứng; minh họa đúng câu "Chuyển nhẹ trọng lượng sang trái".
An toàn: Hai chân luôn chạm sàn; vịn ghế nếu cần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E05/frames/02.png`

```text
E05 – khung 03. Bộ cơ bản – Chuyển trọng tâm.
Tư thế: đứng; minh họa đúng câu "Đổi từ từ sang bên phải".
An toàn: Hai chân luôn chạm sàn; vịn ghế nếu cần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E05/frames/03.png`

```text
E05 – khung 04. Bộ cơ bản – Chuyển trọng tâm.
Tư thế: đứng; minh họa đúng câu "Trở về giữa, giữ nhịp thở đều".
An toàn: Hai chân luôn chạm sàn; vịn ghế nếu cần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E05/frames/04.png`

#### E06 · Đi bộ tại chỗ (4 khung, 03:00)

```text
E06 – khung 01. Bộ cơ bản – Đi bộ tại chỗ.
Tư thế: đứng; minh họa đúng câu "Đứng thẳng gần chỗ vịn". **Có lưng ghế ngay bên cạnh, một tay đặt nhẹ lên lưng ghế.**
An toàn: Không cần nâng gối cao; dừng nếu choáng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E06/frames/01.png`

```text
E06 – khung 02. Bộ cơ bản – Đi bộ tại chỗ.
Tư thế: đứng; minh họa đúng câu "Nhấc chân phải thấp, nhẹ nhàng". **Gối phải nhấc thấp (bàn chân cách sàn khoảng một gang tay), tay vẫn vịn ghế.**
An toàn: Không cần nâng gối cao; dừng nếu choáng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E06/frames/02.png`

```text
E06 – khung 03. Bộ cơ bản – Đi bộ tại chỗ.
Tư thế: đứng; minh họa đúng câu "Đổi sang chân trái và giữ thăng bằng". **Gối trái nhấc thấp, tay vịn ghế, thân thẳng.**
An toàn: Không cần nâng gối cao; dừng nếu choáng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E06/frames/03.png`

```text
E06 – khung 04. Bộ cơ bản – Đi bộ tại chỗ.
Tư thế: đứng; minh họa đúng câu "Bước đều chậm, hít thở tự nhiên". **Bước tại chỗ chậm, gối thấp, tay vịn ghế.**
An toàn: Không cần nâng gối cao; dừng nếu choáng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E06/frames/04.png`

#### E07 · Ngồi thư giãn (4 khung, 01:00)

```text
E07 – khung 01. Bộ cơ bản – Ngồi thư giãn.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Ngồi trên ghế chắc chắn, chân chạm sàn".
An toàn: Không ép hoặc điều khiển nhịp thở quá mức.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E07/frames/01.png`

```text
E07 – khung 02. Bộ cơ bản – Ngồi thư giãn.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Giữ lưng thoải mái, thở tự nhiên".
An toàn: Không ép hoặc điều khiển nhịp thở quá mức.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E07/frames/02.png`

```text
E07 – khung 03. Bộ cơ bản – Ngồi thư giãn.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Buông lỏng vai, hàm và bàn tay".
An toàn: Không ép hoặc điều khiển nhịp thở quá mức.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E07/frames/03.png`

```text
E07 – khung 04. Bộ cơ bản – Ngồi thư giãn.
Tư thế: ngồi trên ghế gỗ có tay vịn, hai bàn chân đặt phẳng trên sàn; minh họa đúng câu "Ngồi yên một lúc, chú ý hơi thở".
An toàn: Không ép hoặc điều khiển nhịp thở quá mức.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal và bối cảnh tham chiếu. Ảnh vuông, toàn thân, không chữ.
```
→ Lưu thành `assets/series/E07/frames/04.png`

### 3.2 Dưỡng sinh phương Đông (60 thức × 3 khung + 12 bộ vịn ghế)

Góc máy mặc định: **chính diện**; các thức có xoay thân dùng **chếch 3/4** (ghi trong prompt).

#### Bát Đoạn Cẩm — Ba Duan Jin — Eight Brocades

##### E101 · Thức 1: Song thủ thác thiên (Two Hands Hold up the Heavens)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đan tay trước bụng, đứng vững. |
| `pose_transition` | Nâng tay chậm qua ngực, lật lòng bàn tay. |
| `pose_end` | Đẩy nhẹ tay lên cao, vươn người, rồi hạ xuống. |

```text
E101 – pose_start. Bát Đoạn Cẩm – thức 1: Song thủ thác thiên (Two Hands Hold up the Heavens). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai bàn chân rộng bằng vai, gối hơi chùng. Mười ngón tay đan nhau, lòng bàn tay ngửa lên, đặt trước bụng dưới.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E101 – pose_transition. Bát Đoạn Cẩm – thức 1: Song thủ thác thiên (Two Hands Hold up the Heavens). Khung 2 – chuyển tiếp.
Tư thế: Hai tay vẫn đan, nâng chậm lên trước ngực; tới ngang ngực thì xoay lòng bàn tay úp vào trong rồi lật ngửa lên trên. Vai thả lỏng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E101 – pose_end. Bát Đoạn Cẩm – thức 1: Song thủ thác thiên (Two Hands Hold up the Heavens). Khung 3 – kết thúc.
Tư thế: Hai tay duỗi lên trên đầu, lòng bàn tay hướng lên trời, khuỷu tay không khóa cứng; cằm hơi thu, mắt nhìn thẳng hoặc hơi lên. Gót chân vẫn chạm đất.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E102 · Thức 2: Tả hữu khai cung (Drawing the Bow to Shoot the Hawk)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đứng tấn cao, hai tay chéo trước ngực. |
| `pose_transition` | Kéo cung: tay phải kéo về, tay trái đẩy ra. |
| `pose_end` | Mắt nhìn theo tay trái; đổi bên. |

```text
E102 – pose_start. Bát Đoạn Cẩm – thức 2: Tả hữu khai cung (Drawing the Bow to Shoot the Hawk). Khung 1 – bắt đầu.
Tư thế: Bước chân trái sang ngang, đứng tấn ngựa cao (gối chỉ hơi chùng). Hai tay bắt chéo trước ngực, tay phải ở ngoài.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E102 – pose_transition. Bát Đoạn Cẩm – thức 2: Tả hữu khai cung (Drawing the Bow to Shoot the Hawk). Khung 2 – chuyển tiếp.
Tư thế: Tay phải nắm hờ, kéo ngang về trước ngực phải như kéo dây cung; tay trái làm hình "chữ bát" (ngón trỏ dựng, ngón cái mở) đẩy dần sang trái.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E102 – pose_end. Bát Đoạn Cẩm – thức 2: Tả hữu khai cung (Drawing the Bow to Shoot the Hawk). Khung 3 – kết thúc.
Tư thế: Tay trái duỗi ngang tầm vai bên trái, ngón trỏ dựng; tay phải nắm ở trước vai phải, khuỷu mở sang phải; đầu quay nhẹ nhìn ngón trỏ trái. Sau đó đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E102_chair: Ngồi trên mép ghế chắc, lưng thẳng, làm động tác kéo cung chỉ bằng tay. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E103 · Thức 3: Điều lý tỳ vị, nhất thủ cử (Separating Heaven and Earth)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hai tay ngửa trước bụng. |
| `pose_transition` | Một tay nâng lên, một tay ấn xuống. |
| `pose_end` | Kéo giãn trên dưới, rồi đổi tay. |

```text
E103 – pose_start. Bát Đoạn Cẩm – thức 3: Điều lý tỳ vị, nhất thủ cử (Separating Heaven and Earth). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, gối hơi chùng, hai bàn tay ngửa trước bụng, đầu ngón tay hướng vào nhau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E103 – pose_transition. Bát Đoạn Cẩm – thức 3: Điều lý tỳ vị, nhất thủ cử (Separating Heaven and Earth). Khung 2 – chuyển tiếp.
Tư thế: Tay trái nâng lên qua mặt, lật lòng bàn tay lên; tay phải úp xuống, ép dần xuống dưới.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E103 – pose_end. Bát Đoạn Cẩm – thức 3: Điều lý tỳ vị, nhất thủ cử (Separating Heaven and Earth). Khung 3 – kết thúc.
Tư thế: Tay trái đẩy lên trên đầu, lòng bàn tay hướng trời, ngón tay chỉ sang phải; tay phải ấn xuống cạnh hông phải, lòng bàn tay úp, ngón hướng ra trước. Sau đó đổi bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E104 · Thức 4: Ngũ lao thất thương vãng hậu tiều (Wise Owl Gazes Backwards)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đứng thẳng, tay buông. |
| `pose_transition` | Xoay tay ra ngoài, mở ngực. |
| `pose_end` | Quay đầu nhẹ nhìn ra sau, rồi đổi bên. |

```text
E104 – pose_start. Bát Đoạn Cẩm – thức 4: Ngũ lao thất thương vãng hậu tiều (Wise Owl Gazes Backwards). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai tay buông tự nhiên hai bên, lòng bàn tay hướng vào đùi.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E104 – pose_transition. Bát Đoạn Cẩm – thức 4: Ngũ lao thất thương vãng hậu tiều (Wise Owl Gazes Backwards). Khung 2 – chuyển tiếp.
Tư thế: Hai tay duỗi xuống, xoay cánh tay ra ngoài để lòng bàn tay hướng ra trước, ngực mở nhẹ.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E104 – pose_end. Bát Đoạn Cẩm – thức 4: Ngũ lao thất thương vãng hậu tiều (Wise Owl Gazes Backwards). Khung 3 – kết thúc.
Tư thế: Giữ tay như trên, đầu quay chậm sang trái khoảng 45 độ nhìn ra phía sau (không ngửa cổ, không xoay mạnh). Trở về giữa rồi quay phải.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E105 · Thức 5: Dao đầu bãi vĩ (Sway the Head and Shake the Tail)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tấn cao, tay đặt trên đùi. |
| `pose_transition` | Nghiêng nhẹ sang phải. |
| `pose_end` | Xoay vòng nhỏ qua trái, mông lắc ngược chiều. |

```text
E105 – pose_start. Bát Đoạn Cẩm – thức 5: Dao đầu bãi vĩ (Sway the Head and Shake the Tail). Khung 1 – bắt đầu.
Tư thế: Đứng tấn ngựa rộng nhưng cao (gối hơi chùng), hai bàn tay đặt trên đùi gần gối, lưng thẳng.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E105 – pose_transition. Bát Đoạn Cẩm – thức 5: Dao đầu bãi vĩ (Sway the Head and Shake the Tail). Khung 2 – chuyển tiếp.
Tư thế: Chuyển trọng tâm sang phải, thân trên nghiêng nhẹ sang phải và hơi về trước; đầu vẫn cao hơn tim.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E105 – pose_end. Bát Đoạn Cẩm – thức 5: Dao đầu bãi vĩ (Sway the Head and Shake the Tail). Khung 3 – kết thúc.
Tư thế: Thân trên xoay vòng nhỏ từ phải qua trước sang trái, mông lắc nhẹ ngược chiều (như "lắc đuôi"); trở về giữa rồi làm chiều ngược lại. Biên độ nhỏ.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E105_chair: Ngồi trên ghế, hai tay đặt trên đùi, nghiêng và xoay thân trên biên độ nhỏ, đầu luôn cao hơn tim. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E106 · Thức 6: Lưỡng thủ phàn túc (Two Hands Hold the Feet)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hai tay giơ lên cao. |
| `pose_transition` | Hạ tay, vuốt dọc lưng xuống. |
| `pose_end` | Cúi chậm, tay trượt xuống chân tới mức dễ chịu. |

```text
E106 – pose_start. Bát Đoạn Cẩm – thức 6: Lưỡng thủ phàn túc (Two Hands Hold the Feet). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai tay giơ thẳng lên trên đầu, lòng bàn tay hướng ra trước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E106 – pose_transition. Bát Đoạn Cẩm – thức 6: Lưỡng thủ phàn túc (Two Hands Hold the Feet). Khung 2 – chuyển tiếp.
Tư thế: Hai tay hạ xuống trước ngực, lòng bàn tay úp; luồn ra sau nách, áp dọc lưng xuống tới mông.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E106 – pose_end. Bát Đoạn Cẩm – thức 6: Lưỡng thủ phàn túc (Two Hands Hold the Feet). Khung 3 – kết thúc.
Tư thế: Gập người chậm từ hông về trước (gối hơi chùng), hai tay trượt dọc mặt sau đùi xuống cẳng chân tới mức thoải mái; đầu thả lỏng. Rồi trượt tay lên, đứng thẳng dần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E106_chair: Ngồi trên ghế, hai tay trượt từ đùi xuống cẳng chân tới mức thoải mái, không cúi đầu thấp. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E107 · Thức 7: Toản quyền nộ mục (Clench the Fists and Glare)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tấn cao, nắm tay đặt cạnh eo. |
| `pose_transition` | Đấm chậm ra trước, mắt nhìn theo. |
| `pose_end` | Xoay cổ tay, nắm lại và rút về; đổi bên. |

```text
E107 – pose_start. Bát Đoạn Cẩm – thức 7: Toản quyền nộ mục (Clench the Fists and Glare). Khung 1 – bắt đầu.
Tư thế: Đứng tấn ngựa cao, hai tay nắm hờ đặt cạnh eo, lòng nắm tay ngửa lên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E107 – pose_transition. Bát Đoạn Cẩm – thức 7: Toản quyền nộ mục (Clench the Fists and Glare). Khung 2 – chuyển tiếp.
Tư thế: Nắm tay trái đấm chậm ra trước ngang vai, vừa đi vừa xoay nắm tay úp xuống; mắt mở to nhìn nắm tay.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E107 – pose_end. Bát Đoạn Cẩm – thức 7: Toản quyền nộ mục (Clench the Fists and Glare). Khung 3 – kết thúc.
Tư thế: Tay trái mở ra, xoay cổ tay, nắm lại như nắm vật rồi kéo về cạnh eo; sau đó đổi tay phải.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E108 · Thức 8: Bối hậu thất điên (Bouncing on the Toes)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đứng khép chân, thả lỏng. |
| `pose_transition` | Kiễng gót, vươn người lên. |
| `pose_end` | Hạ gót nhẹ xuống đất. |

```text
E108 – pose_start. Bát Đoạn Cẩm – thức 8: Bối hậu thất điên (Bouncing on the Toes). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai bàn chân khép, hai tay buông tự nhiên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E108 – pose_transition. Bát Đoạn Cẩm – thức 8: Bối hậu thất điên (Bouncing on the Toes). Khung 2 – chuyển tiếp.
Tư thế: Kiễng gót lên chậm, đỉnh đầu như được kéo lên; giữ thăng bằng 1 giây (có thể một tay vịn lưng ghế).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E108 – pose_end. Bát Đoạn Cẩm – thức 8: Bối hậu thất điên (Bouncing on the Toes). Khung 3 – kết thúc.
Tư thế: Hạ gót xuống nhẹ nhàng, thân hơi rung lỏng; không dậm mạnh.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E108_chair: Đứng sau lưng ghế, hai tay vịn lưng ghế, kiễng gót thấp và hạ gót thật nhẹ. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

#### Dịch Cân Kinh — Yi Jin Jing — 12 forms

##### E201 · Thức 1: Vi Đà hiến chử — thức 1 (Wei Tuo Offers the Pestle I)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đưa hai tay ra trước ngang vai. |
| `pose_transition` | Khuỳnh tay, thu về trước ngực. |
| `pose_end` | Chắp tay trước ngực, tĩnh tâm. |

```text
E201 – pose_start. Dịch Cân Kinh – thức 1: Vi Đà hiến chử — thức 1 (Wei Tuo Offers the Pestle I). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, chân rộng bằng vai, hai tay đưa ra trước ngang vai, lòng bàn tay hướng vào nhau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E201 – pose_transition. Dịch Cân Kinh – thức 1: Vi Đà hiến chử — thức 1 (Wei Tuo Offers the Pestle I). Khung 2 – chuyển tiếp.
Tư thế: Khuỳnh hai khuỷu tay, thu hai bàn tay về trước ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E201 – pose_end. Dịch Cân Kinh – thức 1: Vi Đà hiến chử — thức 1 (Wei Tuo Offers the Pestle I). Khung 3 – kết thúc.
Tư thế: Hai lòng bàn tay chắp vào nhau trước ngực (cách ngực một nắm tay), ngón tay hướng lên, vai thả lỏng; mắt nhìn ra trước, bình thản.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E202 · Thức 2: Vi Đà hiến chử — thức 2 (Wei Tuo Offers the Pestle II)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Nâng khuỷu ngang vai. |
| `pose_transition` | Mở tay sang hai bên. |
| `pose_end` | Dựng cổ tay, đẩy nhẹ ra hai bên. |

```text
E202 – pose_start. Dịch Cân Kinh – thức 2: Vi Đà hiến chử — thức 2 (Wei Tuo Offers the Pestle II). Khung 1 – bắt đầu.
Tư thế: Từ tư thế chắp tay trước ngực, nâng khuỷu tay lên ngang vai, đầu ngón tay hướng vào ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E202 – pose_transition. Dịch Cân Kinh – thức 2: Vi Đà hiến chử — thức 2 (Wei Tuo Offers the Pestle II). Khung 2 – chuyển tiếp.
Tư thế: Hai cánh tay mở dần sang hai bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E202 – pose_end. Dịch Cân Kinh – thức 2: Vi Đà hiến chử — thức 2 (Wei Tuo Offers the Pestle II). Khung 3 – kết thúc.
Tư thế: Hai tay duỗi ngang tầm vai sang hai bên, lòng bàn tay hướng ra ngoài, ngón tay dựng lên, đẩy nhẹ ra như đẩy tường.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E203 · Thức 3: Vi Đà hiến chử — thức 3 (Wei Tuo Offers the Pestle III)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay ngang vai. |
| `pose_transition` | Lật tay, vòng lên cao. |
| `pose_end` | Nâng hai tay trên đầu như đỡ vật. |

```text
E203 – pose_start. Dịch Cân Kinh – thức 3: Vi Đà hiến chử — thức 3 (Wei Tuo Offers the Pestle III). Khung 1 – bắt đầu.
Tư thế: Hai tay ngang vai sang hai bên, lòng bàn tay úp.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E203 – pose_transition. Dịch Cân Kinh – thức 3: Vi Đà hiến chử — thức 3 (Wei Tuo Offers the Pestle III). Khung 2 – chuyển tiếp.
Tư thế: Lật lòng bàn tay ngửa, hai tay vòng lên trên đầu.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E203 – pose_end. Dịch Cân Kinh – thức 3: Vi Đà hiến chử — thức 3 (Wei Tuo Offers the Pestle III). Khung 3 – kết thúc.
Tư thế: Hai bàn tay trên đầu, lòng bàn tay hướng lên như nâng vật, khuỷu hơi cong; gót chân vẫn chạm đất (phiên bản cho người lớn tuổi).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E204 · Thức 4: Trích tinh hoán đẩu (Plucking Stars and Changing the Dipper)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay phải đưa xuống trước hông trái. |
| `pose_transition` | Vung tay lên, tay kia đặt sau lưng. |
| `pose_end` | Bàn tay khum trên cao, mắt nhìn theo; đổi bên. |

```text
E204 – pose_start. Dịch Cân Kinh – thức 4: Trích tinh hoán đẩu (Plucking Stars and Changing the Dipper). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, tay phải đưa xuống trước hông trái, thân hơi xoay trái.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E204 – pose_transition. Dịch Cân Kinh – thức 4: Trích tinh hoán đẩu (Plucking Stars and Changing the Dipper). Khung 2 – chuyển tiếp.
Tư thế: Tay phải vung lên vòng qua trước mặt sang phía trên bên phải; tay trái đặt mu bàn tay lên thắt lưng sau.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E204 – pose_end. Dịch Cân Kinh – thức 4: Trích tinh hoán đẩu (Plucking Stars and Changing the Dipper). Khung 3 – kết thúc.
Tư thế: Tay phải ở trên đầu phía phải, bàn tay khum như hái sao, lòng bàn tay hướng xuống; mắt nhìn lên lòng bàn tay; rồi đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E205 · Thức 5: Đảo duệ cửu ngưu vĩ (Pulling Nine Oxen by the Tail)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Chùng gối trước, hai tay nắm trước sau. |
| `pose_transition` | Dồn trọng tâm về sau, xoay eo. |
| `pose_end` | Kéo như kéo đuôi trâu; đổi bên. |

```text
E205 – pose_start. Dịch Cân Kinh – thức 5: Đảo duệ cửu ngưu vĩ (Pulling Nine Oxen by the Tail). Khung 1 – bắt đầu.
Tư thế: Bước chân trái lên, đứng chùng gối trước (cung bộ thấp vừa), tay trái nắm hờ đưa ra trước ngang vai, tay phải nắm hờ ở phía sau ngang hông.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E205 – pose_transition. Dịch Cân Kinh – thức 5: Đảo duệ cửu ngưu vĩ (Pulling Nine Oxen by the Tail). Khung 2 – chuyển tiếp.
Tư thế: Chuyển trọng tâm về chân sau, xoay eo, hai tay xoắn như cuộn dây.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E205 – pose_end. Dịch Cân Kinh – thức 5: Đảo duệ cửu ngưu vĩ (Pulling Nine Oxen by the Tail). Khung 3 – kết thúc.
Tư thế: Trọng tâm ở chân sau, thân xoay nhẹ, hai tay nắm như đang kéo đuôi trâu về phía sau; rồi đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E206 · Thức 6: Xuất trảo lượng sí (Showing Claws and Spreading Wings)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Dựng hai bàn tay trước ngực. |
| `pose_transition` | Đẩy chậm ra trước, xòe ngón. |
| `pose_end` | Duỗi tay, xòe ngón như móng vuốt; thu về. |

```text
E206 – pose_start. Dịch Cân Kinh – thức 6: Xuất trảo lượng sí (Showing Claws and Spreading Wings). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai bàn tay dựng trước ngực, lòng bàn tay hướng ra trước, ngón tay hướng lên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E206 – pose_transition. Dịch Cân Kinh – thức 6: Xuất trảo lượng sí (Showing Claws and Spreading Wings). Khung 2 – chuyển tiếp.
Tư thế: Đẩy chậm hai tay ra trước, các ngón tay xòe dần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E206 – pose_end. Dịch Cân Kinh – thức 6: Xuất trảo lượng sí (Showing Claws and Spreading Wings). Khung 3 – kết thúc.
Tư thế: Hai tay duỗi ra trước ngang vai, lòng bàn tay hướng ra trước, ngón xòe rộng như móng vuốt; sau đó thu tay về.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E207 · Thức 7: Cửu quỷ bạt mã đao (Nine Ghosts Drawing Sabres)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay vòng sau đầu, tay kia áp lưng. |
| `pose_transition` | Xoay thân chậm, mở khuỷu tay. |
| `pose_end` | Giữ ngực mở, cổ thẳng; đổi bên. |

```text
E207 – pose_start. Dịch Cân Kinh – thức 7: Cửu quỷ bạt mã đao (Nine Ghosts Drawing Sabres). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng; tay phải vòng qua sau đầu, lòng bàn tay áp nhẹ lên tai trái (không kéo đầu); mu bàn tay trái áp lên lưng giữa.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E207 – pose_transition. Dịch Cân Kinh – thức 7: Cửu quỷ bạt mã đao (Nine Ghosts Drawing Sabres). Khung 2 – chuyển tiếp.
Tư thế: Xoay thân chậm sang trái, mở khuỷu tay phải ra sau.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E207 – pose_end. Dịch Cân Kinh – thức 7: Cửu quỷ bạt mã đao (Nine Ghosts Drawing Sabres). Khung 3 – kết thúc.
Tư thế: Thân xoay sang trái vừa phải, khuỷu tay phải mở, ngực mở; cổ thẳng tự nhiên. Trở về rồi đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E208 · Thức 8: Tam bàn lạc địa (Three Plates Landing)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Chân rộng, tay ngửa trước ngực. |
| `pose_transition` | Chùng gối, lật tay ấn xuống. |
| `pose_end` | Tay ngang gối như đặt đĩa; đứng lên nâng tay. |

```text
E208 – pose_start. Dịch Cân Kinh – thức 8: Tam bàn lạc địa (Three Plates Landing). Khung 1 – bắt đầu.
Tư thế: Bước chân trái sang ngang, chân rộng hơn vai, hai bàn tay ngửa trước ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E208 – pose_transition. Dịch Cân Kinh – thức 8: Tam bàn lạc địa (Three Plates Landing). Khung 2 – chuyển tiếp.
Tư thế: Chùng gối xuống tấn ngựa cao, hai bàn tay lật úp, ấn dần xuống.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E208 – pose_end. Dịch Cân Kinh – thức 8: Tam bàn lạc địa (Three Plates Landing). Khung 3 – kết thúc.
Tư thế: Tấn cao, hai bàn tay úp ở ngang gối hai bên như đặt đĩa xuống đất; rồi lật ngửa tay, đứng lên nâng tay về ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E209 · Thức 9: Thanh long thám trảo (Green Dragon Extending Claws)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Nắm tay cạnh eo. |
| `pose_transition` | Vươn vuốt rồng sang trái, xoay thân. |
| `pose_end` | Cúi nhẹ, vươn tay xuống, quét về; đổi bên. |

```text
E209 – pose_start. Dịch Cân Kinh – thức 9: Thanh long thám trảo (Green Dragon Extending Claws). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai tay nắm hờ đặt cạnh eo.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E209 – pose_transition. Dịch Cân Kinh – thức 9: Thanh long thám trảo (Green Dragon Extending Claws). Khung 2 – chuyển tiếp.
Tư thế: Tay phải mở thành vuốt rồng, vươn sang phía trước bên trái, thân xoay trái.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E209 – pose_end. Dịch Cân Kinh – thức 9: Thanh long thám trảo (Green Dragon Extending Claws). Khung 3 – kết thúc.
Tư thế: Thân cúi nhẹ về trước bên trái, tay phải vươn xuống phía bàn chân trái tới mức thoải mái rồi quét ngang trở về; đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E210 · Thức 10: Ngọa hổ phác thực (Crouching Tiger Pounces)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Chùng gối trước, tay vuốt hổ. |
| `pose_transition` | Đẩy tay ra trước và xuống. |
| `pose_end` | Nghiêng người như hổ vồ, tay đặt lên gối; đổi bên. |

```text
E210 – pose_start. Dịch Cân Kinh – thức 10: Ngọa hổ phác thực (Crouching Tiger Pounces). Khung 1 – bắt đầu.
Tư thế: Bước chân trái lên chùng gối trước, hai tay làm vuốt hổ ở ngang vai.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E210 – pose_transition. Dịch Cân Kinh – thức 10: Ngọa hổ phác thực (Crouching Tiger Pounces). Khung 2 – chuyển tiếp.
Tư thế: Đẩy hai tay ra trước và xuống, thân nghiêng nhẹ về trước.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E210 – pose_end. Dịch Cân Kinh – thức 10: Ngọa hổ phác thực (Crouching Tiger Pounces). Khung 3 – kết thúc.
Tư thế: Thân nghiêng về trước, hai bàn tay vuốt hổ hướng xuống phía trước (phiên bản nhẹ: tay đặt trên gối hoặc lưng ghế), đầu ngẩng nhẹ; trở về, đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E210_chair: Đứng trước ghế, hai bàn tay đặt lên mặt ghế thay vì chạm sàn. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E211 · Thức 11: Đả cung (Bowing Posture)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hai tay áp tai, ngón đặt sau gáy. |
| `pose_transition` | Gõ nhẹ ngón tay sau đầu. |
| `pose_end` | Cúi chậm, cuộn lưng xuống, rồi cuộn lên. |

```text
E211 – pose_start. Dịch Cân Kinh – thức 11: Đả cung (Bowing Posture). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai lòng bàn tay áp lên tai, các ngón tay đặt sau gáy.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E211 – pose_transition. Dịch Cân Kinh – thức 11: Đả cung (Bowing Posture). Khung 2 – chuyển tiếp.
Tư thế: Gõ nhẹ các ngón tay lên sau đầu vài lần ("minh thiên cổ").
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E211 – pose_end. Dịch Cân Kinh – thức 11: Đả cung (Bowing Posture). Khung 3 – kết thúc.
Tư thế: Cúi người chậm từ hông, cuộn cột sống xuống tới mức thoải mái, tay vẫn ôm sau đầu nhưng không kéo cổ; rồi cuộn dần lên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E212 · Thức 12: Điệu vĩ (Wagging the Tail)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đan tay đẩy ra trước. |
| `pose_transition` | Cúi nhẹ, tay đan đẩy xuống. |
| `pose_end` | Quay đầu nhìn sau, hông lắc cùng bên; đổi bên. |

```text
E212 – pose_start. Dịch Cân Kinh – thức 12: Điệu vĩ (Wagging the Tail). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, mười ngón tay đan nhau trước ngực, đẩy ra trước.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E212 – pose_transition. Dịch Cân Kinh – thức 12: Điệu vĩ (Wagging the Tail). Khung 2 – chuyển tiếp.
Tư thế: Hai tay đan đẩy xuống, cúi người nhẹ, lòng bàn tay hướng xuống đất (biên độ nhỏ).
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E212 – pose_end. Dịch Cân Kinh – thức 12: Điệu vĩ (Wagging the Tail). Khung 3 – kết thúc.
Tư thế: Giữ người hơi cúi, quay đầu nhìn ra sau qua vai trái trong khi hông lắc nhẹ sang trái (vẫy đuôi); đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

#### Ngũ Cầm Hí — Wu Qin Xi — Five Animals

##### E301 · Thức 1: Hổ giơ vuốt (Tiger Raising)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay vuốt hổ trước bụng. |
| `pose_transition` | Nâng tay lên ngực, nắm rồi mở. |
| `pose_end` | Vươn vuốt lên cao, rồi ấn xuống. |

```text
E301 – pose_start. Ngũ Cầm Hí – thức 1: Hổ giơ vuốt (Tiger Raising). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai bàn tay trước bụng, lòng bàn tay úp, các ngón xòe và cong lại như vuốt hổ.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E301 – pose_transition. Ngũ Cầm Hí – thức 1: Hổ giơ vuốt (Tiger Raising). Khung 2 – chuyển tiếp.
Tư thế: Hai tay nâng lên dọc thân tới ngực, nắm lại thành nắm tay rồi mở ra.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E301 – pose_end. Ngũ Cầm Hí – thức 1: Hổ giơ vuốt (Tiger Raising). Khung 3 – kết thúc.
Tư thế: Hai tay vươn lên trên đầu, lòng bàn tay hướng ra trước, ngón cong như vuốt, thân vươn dài; rồi ấn xuống trước bụng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E302 · Thức 2: Hổ vồ mồi (Tiger Seizing)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Vuốt hổ ngang vai, cúi nhẹ. |
| `pose_transition` | Duỗi thân, vươn tay ra trước. |
| `pose_end` | Bước tới, vồ xuống ngang gối; đổi bên. |

```text
E302 – pose_start. Ngũ Cầm Hí – thức 2: Hổ vồ mồi (Tiger Seizing). Khung 1 – bắt đầu.
Tư thế: Hai tay làm vuốt hổ ngang vai, thân hơi cúi về trước, gối hơi chùng.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E302 – pose_transition. Ngũ Cầm Hí – thức 2: Hổ vồ mồi (Tiger Seizing). Khung 2 – chuyển tiếp.
Tư thế: Thân duỗi thẳng lên, hai tay vươn ra trước.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E302 – pose_end. Ngũ Cầm Hí – thức 2: Hổ vồ mồi (Tiger Seizing). Khung 3 – kết thúc.
Tư thế: Bước chân trái lên, gót chạm đất; hai tay vồ ra trước và xuống ngang gối (cúi biên độ nhỏ); trở về, đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E303 · Thức 3: Hươu húc gạc (Deer Colliding)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay sừng hươu cạnh eo. |
| `pose_transition` | Bước gót, vung tay vòng cung. |
| `pose_end` | Xoay thân nhìn về gót chân; đổi bên. |

```text
E303 – pose_start. Ngũ Cầm Hí – thức 3: Hươu húc gạc (Deer Colliding). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai tay làm sừng hươu (ngón giữa và áp út gập, các ngón khác duỗi) đặt cạnh eo.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E303 – pose_transition. Ngũ Cầm Hí – thức 3: Hươu húc gạc (Deer Colliding). Khung 2 – chuyển tiếp.
Tư thế: Bước chân trái ra trước bằng gót, hai tay vung lên vòng cung sang phải.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E303 – pose_end. Ngũ Cầm Hí – thức 3: Hươu húc gạc (Deer Colliding). Khung 3 – kết thúc.
Tư thế: Thân xoay sang trái, hai tay lên cao phía sau bên trái, mắt nhìn về gót chân phải (xoay vừa phải); trở về, đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E304 · Thức 4: Hươu chạy (Deer Running)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Chùng gối trước, tay sừng hươu ra trước. |
| `pose_transition` | Dồn về sau, cong lưng. |
| `pose_end` | Lưng cong như cung, rồi trở về; đổi chân. |

```text
E304 – pose_start. Ngũ Cầm Hí – thức 4: Hươu chạy (Deer Running). Khung 1 – bắt đầu.
Tư thế: Bước chân trái lên chùng gối trước, hai tay sừng hươu đưa ra trước ngang vai.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E304 – pose_transition. Ngũ Cầm Hí – thức 4: Hươu chạy (Deer Running). Khung 2 – chuyển tiếp.
Tư thế: Dồn trọng tâm về sau, lưng tròn lại, hai cánh tay duỗi ra trước, cổ tay xoay vào trong.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E304 – pose_end. Ngũ Cầm Hí – thức 4: Hươu chạy (Deer Running). Khung 3 – kết thúc.
Tư thế: Lưng cong như cánh cung, đầu cúi nhẹ giữa hai tay; sau đó trở về đứng thẳng, đổi chân.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E305 · Thức 5: Gấu lắc mình (Bear Swaying)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay chân gấu trước bụng. |
| `pose_transition` | Nhấc hông, bước chân phải. |
| `pose_end` | Dồn trọng tâm, thân lắc nhẹ; đổi bên. |

```text
E305 – pose_start. Ngũ Cầm Hí – thức 5: Gấu lắc mình (Bear Swaying). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai tay nắm hờ như bàn chân gấu trước bụng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E305 – pose_transition. Ngũ Cầm Hí – thức 5: Gấu lắc mình (Bear Swaying). Khung 2 – chuyển tiếp.
Tư thế: Nhấc nhẹ hông phải, gối phải hơi gập, bước chân phải ra trước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E305 – pose_end. Ngũ Cầm Hí – thức 5: Gấu lắc mình (Bear Swaying). Khung 3 – kết thúc.
Tư thế: Dồn trọng tâm lên chân phải, thân lắc nhẹ, hai tay đung đưa tự nhiên trước sau; đổi bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E306 · Thức 6: Gấu xoa bụng (Bear Rubbing)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay chân gấu trước rốn. |
| `pose_transition` | Xoay eo, tay vẽ vòng quanh rốn. |
| `pose_end` | Hoàn tất vòng, đổi chiều. |

```text
E306 – pose_start. Ngũ Cầm Hí – thức 6: Gấu xoa bụng (Bear Rubbing). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, gối hơi chùng, hai tay chân gấu đặt trước rốn, thân hơi nghiêng về trước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E306 – pose_transition. Ngũ Cầm Hí – thức 6: Gấu xoa bụng (Bear Rubbing). Khung 2 – chuyển tiếp.
Tư thế: Thân và eo xoay vòng theo chiều kim đồng hồ, hai tay vẽ vòng quanh rốn.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E306 – pose_end. Ngũ Cầm Hí – thức 6: Gấu xoa bụng (Bear Rubbing). Khung 3 – kết thúc.
Tư thế: Hoàn tất vòng tròn, hai tay về trước rốn; sau đó xoay ngược chiều.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E307 · Thức 7: Khỉ cảnh giác (Monkey Alert)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay móc khỉ trước bụng. |
| `pose_transition` | Nhún vai, nâng tay, kiễng gót nhẹ. |
| `pose_end` | Quay đầu cảnh giác, rồi hạ xuống; đổi bên. |

```text
E307 – pose_start. Ngũ Cầm Hí – thức 7: Khỉ cảnh giác (Monkey Alert). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai bàn tay trước bụng, các đầu ngón chụm lại như móc khỉ.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E307 – pose_transition. Ngũ Cầm Hí – thức 7: Khỉ cảnh giác (Monkey Alert). Khung 2 – chuyển tiếp.
Tư thế: Nhún vai, nâng hai tay lên trước ngực, kiễng gót nhẹ (có thể vịn ghế).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E307 – pose_end. Ngũ Cầm Hí – thức 7: Khỉ cảnh giác (Monkey Alert). Khung 3 – kết thúc.
Tư thế: Đầu quay sang trái như khỉ cảnh giác, rồi hạ gót, hai tay úp hạ xuống bụng; đổi bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E308 · Thức 8: Khỉ hái quả (Monkey Plucking)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Lùi nhẹ, tay móc khỉ. |
| `pose_transition` | Vươn tay hái quả trên cao. |
| `pose_end` | Mang quả về ngực, tay kia đỡ; đổi bên. |

```text
E308 – pose_start. Ngũ Cầm Hí – thức 8: Khỉ hái quả (Monkey Plucking). Khung 1 – bắt đầu.
Tư thế: Bước chân trái lùi nhẹ, hai tay móc khỉ cạnh hông.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E308 – pose_transition. Ngũ Cầm Hí – thức 8: Khỉ hái quả (Monkey Plucking). Khung 2 – chuyển tiếp.
Tư thế: Bước lên, tay phải vươn lên cao phía trước như hái quả, kiễng gót nhẹ (hai chân vẫn chạm đất).
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E308 – pose_end. Ngũ Cầm Hí – thức 8: Khỉ hái quả (Monkey Plucking). Khung 3 – kết thúc.
Tư thế: Tay phải nắm "quả" kéo về ngang ngực, tay trái đỡ phía dưới; đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E309 · Thức 9: Chim vươn cánh (Bird Stretching)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hai tay chồng trước bụng. |
| `pose_transition` | Nâng tay lên cao, mở ngực. |
| `pose_end` | Mở tay ra sau như cánh; đổi bên. |

```text
E309 – pose_start. Ngũ Cầm Hí – thức 9: Chim vươn cánh (Bird Stretching). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai bàn tay chồng lên nhau trước bụng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E309 – pose_transition. Ngũ Cầm Hí – thức 9: Chim vươn cánh (Bird Stretching). Khung 2 – chuyển tiếp.
Tư thế: Hai tay nâng lên trên đầu, lòng bàn tay úp, ngực mở.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E309 – pose_end. Ngũ Cầm Hí – thức 9: Chim vươn cánh (Bird Stretching). Khung 3 – kết thúc.
Tư thế: Hạ tay, hai tay mở ra sau như đôi cánh, chân trái nhấc nhẹ ra sau (phiên bản nhẹ: hai chân trên đất, một tay vịn ghế); đổi bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E309_chair: Một tay vịn lưng ghế, hai chân luôn trên sàn, chỉ mở tay còn lại như cánh. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E310 · Thức 10: Chim bay (Bird Flying)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay trước bụng, gối chùng. |
| `pose_transition` | Dang tay như cánh chim. |
| `pose_end` | Tay lên cao rồi hạ; đổi chân. |

```text
E310 – pose_start. Ngũ Cầm Hí – thức 10: Chim bay (Bird Flying). Khung 1 – bắt đầu.
Tư thế: Gối hơi chùng, hai bàn tay trước bụng, lòng bàn tay hướng vào nhau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E310 – pose_transition. Ngũ Cầm Hí – thức 10: Chim bay (Bird Flying). Khung 2 – chuyển tiếp.
Tư thế: Hai tay nâng sang hai bên như cánh chim tới ngang vai, gối phải nhấc nhẹ (hoặc vịn ghế, không nhấc gối).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E310 – pose_end. Ngũ Cầm Hí – thức 10: Chim bay (Bird Flying). Khung 3 – kết thúc.
Tư thế: Hai tay lên cao trên đầu, mu bàn tay hướng vào nhau, rồi hạ xuống trước bụng; đổi chân.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E310_chair: Một tay vịn lưng ghế, không nhấc gối, chỉ dang tay còn lại như cánh. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

#### Lục Tự Quyết — Liu Zi Jue — Six Sounds

##### E401 · Thức 1: Âm Xu (嘘) (Xu / xū)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hai tay ngửa cạnh eo. |
| `pose_transition` | Xoay thân, đẩy tay ra, mắt mở to. |
| `pose_end` | Thở ra đọc nhẹ "xū"; đổi bên. |

```text
E401 – pose_start. Lục Tự Quyết – thức 1: Âm Xu (嘘) (Xu / xū). Khung 1 – bắt đầu.
Tư thế: Đứng (hoặc ngồi) thẳng, hai bàn tay ngửa đặt cạnh eo.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E401 – pose_transition. Lục Tự Quyết – thức 1: Âm Xu (嘘) (Xu / xū). Khung 2 – chuyển tiếp.
Tư thế: Thân xoay nhẹ sang trái, bàn tay phải ngửa đẩy chậm ra trước bên trái ngang vai, mắt mở to.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E401 – pose_end. Lục Tự Quyết – thức 1: Âm Xu (嘘) (Xu / xū). Khung 3 – kết thúc.
Tư thế: Tay phải duỗi hết mức thoải mái trong khi thở ra phát âm "xū" nhẹ; thu tay về eo, đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E402 · Thức 2: Âm He (呵) (He / hē)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay như vốc nước trước bụng. |
| `pose_transition` | Vốc tay lên ngực. |
| `pose_end` | Lật tay ấn xuống, thở ra đọc "hē". |

```text
E402 – pose_start. Lục Tự Quyết – thức 2: Âm He (呵) (He / hē). Khung 1 – bắt đầu.
Tư thế: Hai tay để trước bụng, hai ngón út chạm nhau như vốc nước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E402 – pose_transition. Lục Tự Quyết – thức 2: Âm He (呵) (He / hē). Khung 2 – chuyển tiếp.
Tư thế: Nâng hai tay vốc lên tới ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E402 – pose_end. Lục Tự Quyết – thức 2: Âm He (呵) (He / hē). Khung 3 – kết thúc.
Tư thế: Lật lòng bàn tay úp, ấn chậm xuống bụng trong khi thở ra phát âm "hē".
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E403 · Thức 3: Âm Hu (呼) (Hu / hū)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay trước rốn. |
| `pose_transition` | Mở tay ra hai bên. |
| `pose_end` | Thở ra đọc "hū", thu tay về. |

```text
E403 – pose_start. Lục Tự Quyết – thức 3: Âm Hu (呼) (Hu / hū). Khung 1 – bắt đầu.
Tư thế: Hai bàn tay trước rốn, lòng bàn tay hướng vào bụng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E403 – pose_transition. Lục Tự Quyết – thức 3: Âm Hu (呼) (Hu / hū). Khung 2 – chuyển tiếp.
Tư thế: Hai tay mở dần ra hai bên, lòng bàn tay hướng vào nhau, cách nhau rộng hơn thân.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E403 – pose_end. Lục Tự Quyết – thức 3: Âm Hu (呼) (Hu / hū). Khung 3 – kết thúc.
Tư thế: Giữ tay mở trong khi thở ra phát âm "hū", rồi thu tay về trước rốn.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E404 · Thức 4: Âm Si (呬) (Si / sī)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay trước ngực, đầu ngón hướng nhau. |
| `pose_transition` | Kéo vai ra sau, mở ngực. |
| `pose_end` | Đẩy tay ra trước, thở ra đọc "sī". |

```text
E404 – pose_start. Lục Tự Quyết – thức 4: Âm Si (呬) (Si / sī). Khung 1 – bắt đầu.
Tư thế: Hai bàn tay nâng lên trước ngực, đầu ngón tay hướng vào nhau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E404 – pose_transition. Lục Tự Quyết – thức 4: Âm Si (呬) (Si / sī). Khung 2 – chuyển tiếp.
Tư thế: Kéo vai ra sau nhẹ, ngực mở, cằm hơi thu.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E404 – pose_end. Lục Tự Quyết – thức 4: Âm Si (呬) (Si / sī). Khung 3 – kết thúc.
Tư thế: Hai bàn tay dựng lên đẩy ra trước trong khi thở ra phát âm "sī"; thu tay về.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E405 · Thức 5: Âm Chui (吹) (Chui / chuī)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay đặt sau thắt lưng. |
| `pose_transition` | Vuốt xuống hông, vòng ra trước. |
| `pose_end` | Chùng gối, ôm vòng, thở ra đọc "chuī". |

```text
E405 – pose_start. Lục Tự Quyết – thức 5: Âm Chui (吹) (Chui / chuī). Khung 1 – bắt đầu.
Tư thế: Hai bàn tay đặt sau thắt lưng (vùng thận).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E405 – pose_transition. Lục Tự Quyết – thức 5: Âm Chui (吹) (Chui / chuī). Khung 2 – chuyển tiếp.
Tư thế: Hai tay vuốt xuống dọc hông rồi vòng ra trước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E405 – pose_end. Lục Tự Quyết – thức 5: Âm Chui (吹) (Chui / chuī). Khung 3 – kết thúc.
Tư thế: Gối chùng nhẹ (hoặc ngồi), hai tay ôm vòng trước gối trong khi thở ra phát âm "chuī"; đứng lên, tay về sau lưng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E406 · Thức 6: Âm Xi (嘻) (Xi / xī)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Mu bàn tay áp nhau trước bụng. |
| `pose_transition` | Nâng lên ngực, tách ra lên cao. |
| `pose_end` | Hạ tay sang hai bên, thở ra đọc "xī". |

```text
E406 – pose_start. Lục Tự Quyết – thức 6: Âm Xi (嘻) (Xi / xī). Khung 1 – bắt đầu.
Tư thế: Hai mu bàn tay áp vào nhau trước bụng, ngón tay hướng xuống.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E406 – pose_transition. Lục Tự Quyết – thức 6: Âm Xi (嘻) (Xi / xī). Khung 2 – chuyển tiếp.
Tư thế: Nâng tay lên tới ngực, rồi tách ra đưa lên cao sang hai bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E406 – pose_end. Lục Tự Quyết – thức 6: Âm Xi (嘻) (Xi / xī). Khung 3 – kết thúc.
Tư thế: Hạ tay xuống và tách sang hai bên ngang hông trong khi thở ra phát âm "xī".
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

#### Thái Cực Quyền 24 thức — Simplified Taijiquan 24 Forms

##### E501 · Thức 1: Khởi thế (Commencing Form)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Đứng khép chân. |
| `pose_transition` | Bước rộng vai, nâng tay ngang vai. |
| `pose_end` | Chùng gối, ấn tay xuống. |

```text
E501 – pose_start. Thái Cực Quyền 24 thức – thức 1: Khởi thế (Commencing Form). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng, hai chân khép, tay buông.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E501 – pose_transition. Thái Cực Quyền 24 thức – thức 1: Khởi thế (Commencing Form). Khung 2 – chuyển tiếp.
Tư thế: Bước chân trái ra rộng bằng vai, hai tay nâng chậm ra trước ngang vai, lòng bàn tay úp.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E501 – pose_end. Thái Cực Quyền 24 thức – thức 1: Khởi thế (Commencing Form). Khung 3 – kết thúc.
Tư thế: Gối chùng nhẹ, hai bàn tay ấn xuống trước bụng.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E502 · Thức 2: Dã mã phân tông (Part the Wild Horse’s Mane)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Ôm bóng bên phải. |
| `pose_transition` | Bước tới, chuyển trọng tâm. |
| `pose_end` | Tách tay: trước cao, sau thấp. |

```text
E502 – pose_start. Thái Cực Quyền 24 thức – thức 2: Dã mã phân tông (Part the Wild Horse’s Mane). Khung 1 – bắt đầu.
Tư thế: Ôm bóng bên phải: tay phải trên ngang ngực, tay trái dưới ngang bụng, trọng tâm chân phải.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E502 – pose_transition. Thái Cực Quyền 24 thức – thức 2: Dã mã phân tông (Part the Wild Horse’s Mane). Khung 2 – chuyển tiếp.
Tư thế: Bước chân trái lên, chuyển dần sang cung bộ trái.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E502 – pose_end. Thái Cực Quyền 24 thức – thức 2: Dã mã phân tông (Part the Wild Horse’s Mane). Khung 3 – kết thúc.
Tư thế: Cung bộ trái; tay trái ra trước ngang mắt, lòng bàn tay chếch lên; tay phải hạ cạnh hông phải, lòng bàn tay úp. Lặp đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E503 · Thức 3: Bạch hạc lượng sí (White Crane Spreads its Wings)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Theo nửa bước. |
| `pose_transition` | Hư bộ, mũi chân trái chạm đất. |
| `pose_end` | Tay phải cạnh trán, tay trái cạnh hông. |

```text
E503 – pose_start. Thái Cực Quyền 24 thức – thức 3: Bạch hạc lượng sí (White Crane Spreads its Wings). Khung 1 – bắt đầu.
Tư thế: Từ cung bộ, chân phải bước theo nửa bước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E503 – pose_transition. Thái Cực Quyền 24 thức – thức 3: Bạch hạc lượng sí (White Crane Spreads its Wings). Khung 2 – chuyển tiếp.
Tư thế: Trọng tâm về chân phải, chân trái chạm mũi phía trước (hư bộ).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E503 – pose_end. Thái Cực Quyền 24 thức – thức 3: Bạch hạc lượng sí (White Crane Spreads its Wings). Khung 3 – kết thúc.
Tư thế: Tay phải nâng tới cạnh trán, lòng bàn tay hướng vào; tay trái hạ cạnh hông trái, lòng bàn tay úp. Vịn ghế nếu cần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E503_chair: Một tay vịn lưng ghế bên cạnh, hư bộ chỉ chạm nhẹ mũi chân. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E504 · Thức 4: Lâu tất ảo bộ (Brush Knee and Push Forward)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay phải cạnh tai. |
| `pose_transition` | Bước cung bộ trái. |
| `pose_end` | Tay trái quét gối, tay phải đẩy ra. |

```text
E504 – pose_start. Thái Cực Quyền 24 thức – thức 4: Lâu tất ảo bộ (Brush Knee and Push Forward). Khung 1 – bắt đầu.
Tư thế: Tay phải vòng về sau lên cạnh tai, tay trái trước ngực.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E504 – pose_transition. Thái Cực Quyền 24 thức – thức 4: Lâu tất ảo bộ (Brush Knee and Push Forward). Khung 2 – chuyển tiếp.
Tư thế: Bước chân trái lên cung bộ.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E504 – pose_end. Thái Cực Quyền 24 thức – thức 4: Lâu tất ảo bộ (Brush Knee and Push Forward). Khung 3 – kết thúc.
Tư thế: Tay trái quét qua trước gối trái về cạnh hông; tay phải đẩy ra trước ngang mũi. Lặp đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E505 · Thức 5: Thủ huy tỳ bà (Playing the Lute)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Theo nửa bước, dồn sau. |
| `pose_transition` | Gót trái chạm trước. |
| `pose_end` | Hai tay như ôm đàn. |

```text
E505 – pose_start. Thái Cực Quyền 24 thức – thức 5: Thủ huy tỳ bà (Playing the Lute). Khung 1 – bắt đầu.
Tư thế: Chân phải theo nửa bước, trọng tâm về sau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E505 – pose_transition. Thái Cực Quyền 24 thức – thức 5: Thủ huy tỳ bà (Playing the Lute). Khung 2 – chuyển tiếp.
Tư thế: Gót chân trái chạm đất phía trước, mũi chân nhấc.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E505 – pose_end. Thái Cực Quyền 24 thức – thức 5: Thủ huy tỳ bà (Playing the Lute). Khung 3 – kết thúc.
Tư thế: Tay trái ra trước ngang mũi, lòng bàn tay hướng phải; tay phải gần khuỷu trái, như ôm đàn tỳ bà.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E506 · Thức 6: Đảo quyển quăng (Repulse Monkey)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay phải vòng lên tai. |
| `pose_transition` | Lùi chân trái. |
| `pose_end` | Đẩy tay phải, rút tay trái. |

```text
E506 – pose_start. Thái Cực Quyền 24 thức – thức 6: Đảo quyển quăng (Repulse Monkey). Khung 1 – bắt đầu.
Tư thế: Tay phải vòng ra sau và lên cạnh tai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E506 – pose_transition. Thái Cực Quyền 24 thức – thức 6: Đảo quyển quăng (Repulse Monkey). Khung 2 – chuyển tiếp.
Tư thế: Chân trái lùi một bước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E506 – pose_end. Thái Cực Quyền 24 thức – thức 6: Đảo quyển quăng (Repulse Monkey). Khung 3 – kết thúc.
Tư thế: Tay phải đẩy ra trước, tay trái rút về eo lòng bàn tay ngửa. Lặp lùi 4 bước, đổi bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E507 · Thức 7: Tả lãm tước vĩ (Grasp Sparrow’s Tail Left)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Ôm bóng, bước trái. |
| `pose_transition` | Bằng rồi lý: đưa ra, kéo về. |
| `pose_end` | Tễ rồi án: ép và đẩy ra. |

```text
E507 – pose_start. Thái Cực Quyền 24 thức – thức 7: Tả lãm tước vĩ (Grasp Sparrow’s Tail Left). Khung 1 – bắt đầu.
Tư thế: Ôm bóng bên phải, bước chân trái lên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E507 – pose_transition. Thái Cực Quyền 24 thức – thức 7: Tả lãm tước vĩ (Grasp Sparrow’s Tail Left). Khung 2 – chuyển tiếp.
Tư thế: Cung bộ trái, cẳng tay trái đưa ra trước ngang ngực (bằng); kéo về sang phải (lý).
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E507 – pose_end. Thái Cực Quyền 24 thức – thức 7: Tả lãm tước vĩ (Grasp Sparrow’s Tail Left). Khung 3 – kết thúc.
Tư thế: Tay phải áp cổ tay trái ép ra trước (tễ), rồi hai bàn tay đẩy ra trước (án).
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E508 · Thức 8: Hữu lãm tước vĩ (Grasp Sparrow’s Tail Right)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Ôm bóng, bước phải. |
| `pose_transition` | Đưa ra, kéo về. |
| `pose_end` | Ép và đẩy ra. |

```text
E508 – pose_start. Thái Cực Quyền 24 thức – thức 8: Hữu lãm tước vĩ (Grasp Sparrow’s Tail Right). Khung 1 – bắt đầu.
Tư thế: Ôm bóng bên trái, bước chân phải lên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E508 – pose_transition. Thái Cực Quyền 24 thức – thức 8: Hữu lãm tước vĩ (Grasp Sparrow’s Tail Right). Khung 2 – chuyển tiếp.
Tư thế: Cung bộ phải, cẳng tay phải ra trước; kéo về sang trái.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E508 – pose_end. Thái Cực Quyền 24 thức – thức 8: Hữu lãm tước vĩ (Grasp Sparrow’s Tail Right). Khung 3 – kết thúc.
Tư thế: Ép ra trước, rồi hai bàn tay đẩy ra trước.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E509 · Thức 9: Đơn tiên (Single Whip)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay phải thành móc. |
| `pose_transition` | Bước trái, chuyển trọng tâm. |
| `pose_end` | Tay trái đẩy ra, móc phải giữ sau. |

```text
E509 – pose_start. Thái Cực Quyền 24 thức – thức 9: Đơn tiên (Single Whip). Khung 1 – bắt đầu.
Tư thế: Tay phải chụm thành móc (câu thủ) đưa sang phải ngang vai.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E509 – pose_transition. Thái Cực Quyền 24 thức – thức 9: Đơn tiên (Single Whip). Khung 2 – chuyển tiếp.
Tư thế: Bước chân trái sang trái, chuyển dần cung bộ trái.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E509 – pose_end. Thái Cực Quyền 24 thức – thức 9: Đơn tiên (Single Whip). Khung 3 – kết thúc.
Tư thế: Tay trái xoay lòng bàn tay ra ngoài, đẩy ra trước; móc tay phải giữ phía sau bên phải.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E510 · Thức 10: Vân thủ (Cloud Hands)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay ngang ngực và bụng. |
| `pose_transition` | Bước ngang, tay vẽ vòng như mây. |
| `pose_end` | Khép chân, kết thúc vòng. |

```text
E510 – pose_start. Thái Cực Quyền 24 thức – thức 10: Vân thủ (Cloud Hands). Khung 1 – bắt đầu.
Tư thế: Hai tay ngang bụng và ngực, trọng tâm giữa.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E510 – pose_transition. Thái Cực Quyền 24 thức – thức 10: Vân thủ (Cloud Hands). Khung 2 – chuyển tiếp.
Tư thế: Bước ngang sang trái, tay lần lượt vẽ vòng trước mặt như mây trôi, eo xoay theo.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E510 – pose_end. Thái Cực Quyền 24 thức – thức 10: Vân thủ (Cloud Hands). Khung 3 – kết thúc.
Tư thế: Kết thúc vòng tay, chân khép rộng bằng vai. Lặp 3 lần.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E511 · Thức 11: Đơn tiên (lặp) (Single Whip)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay phải thành móc. |
| `pose_transition` | Bước trái. |
| `pose_end` | Đẩy tay trái ra. |

```text
E511 – pose_start. Thái Cực Quyền 24 thức – thức 11: Đơn tiên (lặp) (Single Whip). Khung 1 – bắt đầu.
Tư thế: Như E509: tay phải thành móc sang phải.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E511 – pose_transition. Thái Cực Quyền 24 thức – thức 11: Đơn tiên (lặp) (Single Whip). Khung 2 – chuyển tiếp.
Tư thế: Bước trái, chuyển trọng tâm.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E511 – pose_end. Thái Cực Quyền 24 thức – thức 11: Đơn tiên (lặp) (Single Whip). Khung 3 – kết thúc.
Tư thế: Tay trái đẩy ra trước, móc phải giữ sau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E512 · Thức 12: Cao thám mã (High Pat on Horse)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Theo nửa bước. |
| `pose_transition` | Hư bộ trái. |
| `pose_end` | Tay phải đẩy cao, tay trái ngửa. |

```text
E512 – pose_start. Thái Cực Quyền 24 thức – thức 12: Cao thám mã (High Pat on Horse). Khung 1 – bắt đầu.
Tư thế: Chân phải theo nửa bước.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E512 – pose_transition. Thái Cực Quyền 24 thức – thức 12: Cao thám mã (High Pat on Horse). Khung 2 – chuyển tiếp.
Tư thế: Hư bộ trái (mũi chân trái chạm đất).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E512 – pose_end. Thái Cực Quyền 24 thức – thức 12: Cao thám mã (High Pat on Horse). Khung 3 – kết thúc.
Tư thế: Bàn tay phải đẩy ra trước ngang đầu; tay trái ngửa ở trước eo.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E513 · Thức 13: Hữu đăng cước (Right Heel Kick)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Bắt chéo tay, đứng chân trái. |
| `pose_transition` | Nhấc gối phải. |
| `pose_end` | Duỗi gót thấp, mở tay. |

```text
E513 – pose_start. Thái Cực Quyền 24 thức – thức 13: Hữu đăng cước (Right Heel Kick). Khung 1 – bắt đầu.
Tư thế: Hai tay bắt chéo trước ngực, trọng tâm chân trái (vịn ghế nếu cần).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E513 – pose_transition. Thái Cực Quyền 24 thức – thức 13: Hữu đăng cước (Right Heel Kick). Khung 2 – chuyển tiếp.
Tư thế: Nhấc gối phải lên vừa phải.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E513 – pose_end. Thái Cực Quyền 24 thức – thức 13: Hữu đăng cước (Right Heel Kick). Khung 3 – kết thúc.
Tư thế: Gót phải duỗi nhẹ ra trước chếch phải, thấp hơn hông (biến thể: chỉ nhấc gối hoặc chạm gót xuống đất); hai tay mở sang hai bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E513_chair: Một tay vịn lưng ghế, chỉ nhấc gối thấp, không đá gót. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E514 · Thức 14: Song phong quán nhĩ (Strike to the Ears with Both Fists)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hạ tay cạnh gối. |
| `pose_transition` | Bước cung bộ phải. |
| `pose_end` | Hai nắm tay vòng lên trước. |

```text
E514 – pose_start. Thái Cực Quyền 24 thức – thức 14: Song phong quán nhĩ (Strike to the Ears with Both Fists). Khung 1 – bắt đầu.
Tư thế: Gối phải nhấc, hai tay hạ xuống hai bên gối.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E514 – pose_transition. Thái Cực Quyền 24 thức – thức 14: Song phong quán nhĩ (Strike to the Ears with Both Fists). Khung 2 – chuyển tiếp.
Tư thế: Bước chân phải xuống cung bộ phải.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E514 – pose_end. Thái Cực Quyền 24 thức – thức 14: Song phong quán nhĩ (Strike to the Ears with Both Fists). Khung 3 – kết thúc.
Tư thế: Hai nắm tay vòng từ hai bên lên trước ngang đầu, nắm tay hướng vào nhau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E515 · Thức 15: Chuyển thân tả đăng cước (Turn and Left Heel Kick)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Xoay thân, bắt chéo tay. |
| `pose_transition` | Nhấc gối trái. |
| `pose_end` | Duỗi gót thấp, mở tay. |

```text
E515 – pose_start. Thái Cực Quyền 24 thức – thức 15: Chuyển thân tả đăng cước (Turn and Left Heel Kick). Khung 1 – bắt đầu.
Tư thế: Xoay thân sang trái, hai tay bắt chéo trước ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E515 – pose_transition. Thái Cực Quyền 24 thức – thức 15: Chuyển thân tả đăng cước (Turn and Left Heel Kick). Khung 2 – chuyển tiếp.
Tư thế: Nhấc gối trái (vịn ghế nếu cần).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E515 – pose_end. Thái Cực Quyền 24 thức – thức 15: Chuyển thân tả đăng cước (Turn and Left Heel Kick). Khung 3 – kết thúc.
Tư thế: Gót trái duỗi nhẹ ra trước chếch trái, thấp; tay mở hai bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E515_chair: Một tay vịn lưng ghế, xoay thân nhỏ, chỉ nhấc gối thấp, không đá gót. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E516 · Thức 16: Tả hạ thế độc lập (Left Lower Body and Stand on One Leg)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay móc, tay kia trước ngực. |
| `pose_transition` | Duỗi chân trái, tay vuốt theo (không hạ sâu). |
| `pose_end` | Đứng lên chân trái, nhấc gối nhẹ. |

```text
E516 – pose_start. Thái Cực Quyền 24 thức – thức 16: Tả hạ thế độc lập (Left Lower Body and Stand on One Leg). Khung 1 – bắt đầu.
Tư thế: Tay phải thành móc, tay trái trước ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E516 – pose_transition. Thái Cực Quyền 24 thức – thức 16: Tả hạ thế độc lập (Left Lower Body and Stand on One Leg). Khung 2 – chuyển tiếp.
Tư thế: Biến thể an toàn: chùng gối phải nhẹ, chân trái duỗi sang trái, tay trái vuốt dọc phía trong chân trái (không hạ thấp sâu).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E516 – pose_end. Thái Cực Quyền 24 thức – thức 16: Tả hạ thế độc lập (Left Lower Body and Stand on One Leg). Khung 3 – kết thúc.
Tư thế: Chuyển trọng tâm lên chân trái, nhấc nhẹ gối phải, bàn tay phải ngửa ngang mũi (vịn ghế nếu cần).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E516_chair: Một tay vịn lưng ghế, không hạ thấp người, chỉ duỗi chân sang ngang và nhấc gối thấp. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E517 · Thức 17: Hữu hạ thế độc lập (Right Lower Body and Stand on One Leg)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay móc, tay kia trước ngực. |
| `pose_transition` | Duỗi chân phải, tay vuốt theo. |
| `pose_end` | Đứng lên chân phải, nhấc gối nhẹ. |

```text
E517 – pose_start. Thái Cực Quyền 24 thức – thức 17: Hữu hạ thế độc lập (Right Lower Body and Stand on One Leg). Khung 1 – bắt đầu.
Tư thế: Tay trái thành móc, tay phải trước ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E517 – pose_transition. Thái Cực Quyền 24 thức – thức 17: Hữu hạ thế độc lập (Right Lower Body and Stand on One Leg). Khung 2 – chuyển tiếp.
Tư thế: Biến thể an toàn: chùng gối trái nhẹ, chân phải duỗi sang phải, tay phải vuốt dọc chân phải.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E517 – pose_end. Thái Cực Quyền 24 thức – thức 17: Hữu hạ thế độc lập (Right Lower Body and Stand on One Leg). Khung 3 – kết thúc.
Tư thế: Chuyển trọng tâm lên chân phải, nhấc nhẹ gối trái, bàn tay trái ngửa ngang mũi (vịn ghế nếu cần).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
**Phiên bản vịn ghế / ngồi** (3 ảnh `_chair`, dùng lại 3 prompt trên và thêm câu sau):

```text
Phiên bản an toàn E517_chair: Như E516, đổi bên. Ghế gỗ chắc chắn nhìn rõ trong khung.
```

##### E518 · Thức 18: Tả hữu xuyên thoa (Fair Lady Works the Shuttles)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Ôm bóng, bước trái. |
| `pose_transition` | Tay trái nâng chặn trên trán. |
| `pose_end` | Tay phải đẩy ra; đổi bên. |

```text
E518 – pose_start. Thái Cực Quyền 24 thức – thức 18: Tả hữu xuyên thoa (Fair Lady Works the Shuttles). Khung 1 – bắt đầu.
Tư thế: Ôm bóng, bước chân trái lên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E518 – pose_transition. Thái Cực Quyền 24 thức – thức 18: Tả hữu xuyên thoa (Fair Lady Works the Shuttles). Khung 2 – chuyển tiếp.
Tư thế: Cung bộ trái, cẳng tay trái nâng lên chặn phía trên trán, lòng bàn tay hướng ra.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E518 – pose_end. Thái Cực Quyền 24 thức – thức 18: Tả hữu xuyên thoa (Fair Lady Works the Shuttles). Khung 3 – kết thúc.
Tư thế: Bàn tay phải đẩy ra trước ngang mũi. Đổi bên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E519 · Thức 19: Hải để châm (Needle at Sea Bottom)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Theo nửa bước. |
| `pose_transition` | Hư bộ trái. |
| `pose_end` | Tay phải cắm xuống, nghiêng nhẹ. |

```text
E519 – pose_start. Thái Cực Quyền 24 thức – thức 19: Hải để châm (Needle at Sea Bottom). Khung 1 – bắt đầu.
Tư thế: Chân phải theo nửa bước, trọng tâm về sau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E519 – pose_transition. Thái Cực Quyền 24 thức – thức 19: Hải để châm (Needle at Sea Bottom). Khung 2 – chuyển tiếp.
Tư thế: Hư bộ trái, mũi chân trái chạm đất.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E519 – pose_end. Thái Cực Quyền 24 thức – thức 19: Hải để châm (Needle at Sea Bottom). Khung 3 – kết thúc.
Tư thế: Tay phải từ cạnh tai cắm chéo xuống trước ngang gối, đầu ngón hướng xuống; thân nghiêng nhẹ (biên độ nhỏ).
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E520 · Thức 20: Thiểm thông tý (Fan Through the Back)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Hai tay trước ngực. |
| `pose_transition` | Bước cung bộ trái. |
| `pose_end` | Tay phải trên trán, tay trái đẩy ra. |

```text
E520 – pose_start. Thái Cực Quyền 24 thức – thức 20: Thiểm thông tý (Fan Through the Back). Khung 1 – bắt đầu.
Tư thế: Đứng thẳng từ hư bộ, hai tay trước ngực.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E520 – pose_transition. Thái Cực Quyền 24 thức – thức 20: Thiểm thông tý (Fan Through the Back). Khung 2 – chuyển tiếp.
Tư thế: Bước chân trái lên cung bộ.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E520 – pose_end. Thái Cực Quyền 24 thức – thức 20: Thiểm thông tý (Fan Through the Back). Khung 3 – kết thúc.
Tư thế: Tay phải nâng lên trên trán bên phải, lòng bàn tay hướng ra; tay trái đẩy ra trước ngang mũi.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E521 · Thức 21: Chuyển thân ban lan chùy (Turn, Deflect, Parry and Punch)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Xoay phải, nắm tay trước bụng. |
| `pose_transition` | Quét và chặn, bước trái. |
| `pose_end` | Đấm ra ngang ngực. |

```text
E521 – pose_start. Thái Cực Quyền 24 thức – thức 21: Chuyển thân ban lan chùy (Turn, Deflect, Parry and Punch). Khung 1 – bắt đầu.
Tư thế: Xoay thân sang phải, tay phải nắm lại hạ trước bụng.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E521 – pose_transition. Thái Cực Quyền 24 thức – thức 21: Chuyển thân ban lan chùy (Turn, Deflect, Parry and Punch). Khung 2 – chuyển tiếp.
Tư thế: Nắm tay phải quét ra trước (ban), tay trái chặn ngang (lan), bước chân trái lên.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E521 – pose_end. Thái Cực Quyền 24 thức – thức 21: Chuyển thân ban lan chùy (Turn, Deflect, Parry and Punch). Khung 3 – kết thúc.
Tư thế: Cung bộ trái, nắm tay phải đấm ra trước ngang ngực (chùy), tay trái cạnh cẳng tay phải.
Góc máy: chếch 3/4. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E522 · Thức 22: Như phong tự bế (Apparent Closing a Door)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay trái luồn dưới tay phải. |
| `pose_transition` | Kéo hai tay về ngực. |
| `pose_end` | Đẩy hai tay ra trước. |

```text
E522 – pose_start. Thái Cực Quyền 24 thức – thức 22: Như phong tự bế (Apparent Closing a Door). Khung 1 – bắt đầu.
Tư thế: Bàn tay trái luồn dưới cẳng tay phải.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E522 – pose_transition. Thái Cực Quyền 24 thức – thức 22: Như phong tự bế (Apparent Closing a Door). Khung 2 – chuyển tiếp.
Tư thế: Hai bàn tay tách ra, kéo về trước ngực, trọng tâm về sau.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E522 – pose_end. Thái Cực Quyền 24 thức – thức 22: Như phong tự bế (Apparent Closing a Door). Khung 3 – kết thúc.
Tư thế: Hai bàn tay đẩy ra trước, cung bộ trái.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E523 · Thức 23: Thập tự thủ (Cross Hands)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Xoay phải, tách tay. |
| `pose_transition` | Tay vòng xuống, chân song song. |
| `pose_end` | Bắt chéo tay trước ngực. |

```text
E523 – pose_start. Thái Cực Quyền 24 thức – thức 23: Thập tự thủ (Cross Hands). Khung 1 – bắt đầu.
Tư thế: Xoay thân sang phải, hai tay tách ra hai bên.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E523 – pose_transition. Thái Cực Quyền 24 thức – thức 23: Thập tự thủ (Cross Hands). Khung 2 – chuyển tiếp.
Tư thế: Hai tay vòng xuống dưới, chân khép rộng bằng vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E523 – pose_end. Thái Cực Quyền 24 thức – thức 23: Thập tự thủ (Cross Hands). Khung 3 – kết thúc.
Tư thế: Hai tay bắt chéo trước ngực (tay phải ngoài), lòng bàn tay hướng vào.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

##### E524 · Thức 24: Thu thế (Closing Form)

| Khung | Lời trên app |
|---|---|
| `pose_start` | Tay chéo trước ngực. |
| `pose_transition` | Lật tay úp, tách rộng vai. |
| `pose_end` | Hạ tay, khép chân, đứng tĩnh. |

```text
E524 – pose_start. Thái Cực Quyền 24 thức – thức 24: Thu thế (Closing Form). Khung 1 – bắt đầu.
Tư thế: Hai tay bắt chéo trước ngực.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E524 – pose_transition. Thái Cực Quyền 24 thức – thức 24: Thu thế (Closing Form). Khung 2 – chuyển tiếp.
Tư thế: Lật lòng bàn tay úp, tách tay rộng bằng vai.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```
```text
E524 – pose_end. Thái Cực Quyền 24 thức – thức 24: Thu thế (Closing Form). Khung 3 – kết thúc.
Tư thế: Hạ tay chậm xuống hai bên, khép chân, đứng tĩnh.
Góc máy: chính diện. Giữ đúng nhân vật nam áo teal của reference pack và bối cảnh hệ thống. Ảnh vuông, toàn thân, không chữ.
```

---

## 4. Giọng đọc (lời dẫn)

### 4.1 Đặc tả giọng

- **Giọng:** nữ (hoặc nam) trung niên, giọng chuẩn dễ nghe, ấm, chậm rãi, bình thản; không hô hào, không kịch tính.
- **Tốc độ:** khoảng 110–130 từ/phút, nghỉ 1–2 giây sau mỗi câu.
- **Kỹ thuật:** mono, 48 kHz, −16 LUFS, không reverb nặng, khoảng lặng đầu/cuối 0.3 s.
- **Cách dùng:** mỗi thức là một file, các câu đặt **đúng mốc thời gian** bên dưới. App chia đều thời lượng bước cho các khung ảnh; giọng đọc phải khớp lúc đổi khung.
- **Lục Tự Quyết:** âm "xū, hē, hū, sī, chuī, xī" đọc theo cách phát âm chuẩn mà chuyên gia chỉ định, kèm hơi thở ra dài, nhẹ, không đẩy cạn hơi.

### 4.2 Prompt cho ChatGPT (chỉnh kịch bản)

```text
Dưới đây là kịch bản lời dẫn cho một động tác dưỡng sinh, kèm mốc thời gian.
Hãy giữ nguyên ý và mốc thời gian, chỉnh câu cho tự nhiên khi đọc to bằng tiếng Việt:
câu ngắn, rõ, ấm áp, dành cho người lớn tuổi. Không thêm hứa hẹn sức khỏe, không thêm kỹ thuật mới.
Trả về đúng định dạng "mm:ss  câu".
```

### 4.3 Prompt cho công cụ TTS

```text
Đọc tiếng Việt, giọng ấm, chậm, bình thản như người hướng dẫn dưỡng sinh buổi sáng.
Nghỉ 1–2 giây sau mỗi câu. Không nhấn mạnh quá mức. Âm lượng đều.
```

### 4.4 Kịch bản theo mốc thời gian

Mốc thời gian bằng nhau theo số khung: E01–E07 theo số khung hiện có; phương Đông 3 khung. Câu cuối luôn là lời nhắc an toàn ngắn.

**E01 · Thở tự nhiên** (02:00)

```text
00:00  Thở tự nhiên.
00:02  Ngồi vững, vai và hàm thả lỏng.
00:30  Đặt tay lên bụng nếu thấy dễ chịu.
01:00  Hít thở nhẹ theo nhịp tự nhiên.
01:30  Tiếp tục thở đều, không nín thở.
01:45  Thở đều, nhẹ nhàng.
01:55  Không cố hít quá sâu hoặc nín thở.
```

**E02 · Xoay vai nhẹ** (02:00)

```text
00:00  Xoay vai nhẹ.
00:02  Đứng hoặc ngồi thẳng, thả lỏng vai.
00:30  Nhẹ nhàng nâng và đưa vai ra sau.
01:00  Tiếp tục vòng xoay nhỏ, chậm.
01:30  Hạ vai, thở đều, đổi chiều.
01:45  Thở đều, nhẹ nhàng.
01:55  Không xoay mạnh cổ hay giật vai.
```

**E03 · Bàn tay và cổ chân** (02:00)

```text
00:00  Bàn tay và cổ chân.
00:02  Duỗi nhẹ các ngón tay.
00:20  Nắm tay vừa phải, không siết chặt.
00:40  Mở bàn tay và thả lỏng.
01:00  Ngồi vững, nhấc gót chân.
01:20  Đổi sang nhấc mũi chân.
01:40  Xoay cổ chân nhỏ nếu thoải mái.
01:50  Thở đều, nhẹ nhàng.
01:55  Ngừng nếu xuất hiện đau hoặc tê tăng.
```

**E04 · Nâng hạ hai tay** (02:00)

```text
00:00  Nâng hạ hai tay.
00:02  Đứng vững, tay thả lỏng hai bên.
00:30  Nâng tay chậm đến mức dễ chịu.
01:00  Giữ cổ và vai thả lỏng.
01:30  Hạ tay chậm, thở tự nhiên.
01:45  Thở đều, nhẹ nhàng.
01:55  Không cần nâng quá đầu; tránh gồng vai.
```

**E05 · Chuyển trọng tâm** (02:00)

```text
00:00  Chuyển trọng tâm.
00:02  Đứng rộng bằng vai cạnh chỗ vịn.
00:30  Chuyển nhẹ trọng lượng sang trái.
01:00  Đổi từ từ sang bên phải.
01:30  Trở về giữa, giữ nhịp thở đều.
01:45  Thở đều, nhẹ nhàng.
01:55  Hai chân luôn chạm sàn; vịn ghế nếu cần.
```

**E06 · Đi bộ tại chỗ** (03:00)

```text
00:00  Đi bộ tại chỗ.
00:02  Đứng thẳng gần chỗ vịn.
00:45  Nhấc chân phải thấp, nhẹ nhàng.
01:30  Đổi sang chân trái và giữ thăng bằng.
02:15  Bước đều chậm, hít thở tự nhiên.
02:37  Thở đều, nhẹ nhàng.
02:55  Không cần nâng gối cao; dừng nếu choáng.
```

**E07 · Ngồi thư giãn** (01:00)

```text
00:00  Ngồi thư giãn.
00:02  Ngồi trên ghế chắc chắn, chân chạm sàn.
00:15  Giữ lưng thoải mái, thở tự nhiên.
00:30  Buông lỏng vai, hàm và bàn tay.
00:45  Ngồi yên một lúc, chú ý hơi thở.
00:52  Thở đều, nhẹ nhàng.
00:55  Không ép hoặc điều khiển nhịp thở quá mức.
```

#### Bát Đoạn Cẩm

**E101 · Song thủ thác thiên** (01:15)

```text
00:00  Thức 1: Song thủ thác thiên.
00:02  Đan tay trước bụng, đứng vững.
00:25  Nâng tay chậm qua ngực, lật lòng bàn tay.
00:50  Đẩy nhẹ tay lên cao, vươn người, rồi hạ xuống.
01:02  Hít vào khi nâng tay, thở ra khi hạ tay.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E102 · Tả hữu khai cung** (01:15)

```text
00:00  Thức 2: Tả hữu khai cung.
00:02  Đứng tấn cao, hai tay chéo trước ngực.
00:25  Kéo cung: tay phải kéo về, tay trái đẩy ra.
00:50  Mắt nhìn theo tay trái; đổi bên.
01:02  Hít vào khi tay bắt chéo, thở ra khi kéo cung.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E103 · Điều lý tỳ vị, nhất thủ cử** (01:15)

```text
00:00  Thức 3: Điều lý tỳ vị, nhất thủ cử.
00:02  Hai tay ngửa trước bụng.
00:25  Một tay nâng lên, một tay ấn xuống.
00:50  Kéo giãn trên dưới, rồi đổi tay.
01:02  Hít vào khi tách tay, thở ra khi hai tay trở về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E104 · Ngũ lao thất thương vãng hậu tiều** (01:15)

```text
00:00  Thức 4: Ngũ lao thất thương vãng hậu tiều.
00:02  Đứng thẳng, tay buông.
00:25  Xoay tay ra ngoài, mở ngực.
00:50  Quay đầu nhẹ nhìn ra sau, rồi đổi bên.
01:02  Hít vào khi mở ngực và quay đầu, thở ra khi trở về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E105 · Dao đầu bãi vĩ** (01:15)

```text
00:00  Thức 5: Dao đầu bãi vĩ.
00:02  Tấn cao, tay đặt trên đùi.
00:25  Nghiêng nhẹ sang phải.
00:50  Xoay vòng nhỏ qua trái, mông lắc ngược chiều.
01:02  Thở ra khi nghiêng và xoay, hít vào khi về giữa.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E106 · Lưỡng thủ phàn túc** (01:15)

```text
00:00  Thức 6: Lưỡng thủ phàn túc.
00:02  Hai tay giơ lên cao.
00:25  Hạ tay, vuốt dọc lưng xuống.
00:50  Cúi chậm, tay trượt xuống chân tới mức dễ chịu.
01:02  Thở ra khi cúi xuống, hít vào khi đứng lên.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E107 · Toản quyền nộ mục** (01:15)

```text
00:00  Thức 7: Toản quyền nộ mục.
00:02  Tấn cao, nắm tay đặt cạnh eo.
00:25  Đấm chậm ra trước, mắt nhìn theo.
00:50  Xoay cổ tay, nắm lại và rút về; đổi bên.
01:02  Thở ra khi đấm ra, hít vào khi rút về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E108 · Bối hậu thất điên** (01:15)

```text
00:00  Thức 8: Bối hậu thất điên.
00:02  Đứng khép chân, thả lỏng.
00:25  Kiễng gót, vươn người lên.
00:50  Hạ gót nhẹ xuống đất.
01:02  Hít vào khi kiễng gót, thở ra khi hạ gót.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

#### Dịch Cân Kinh

**E201 · Vi Đà hiến chử — thức 1** (01:15)

```text
00:00  Thức 1: Vi Đà hiến chử — thức 1.
00:02  Đưa hai tay ra trước ngang vai.
00:25  Khuỳnh tay, thu về trước ngực.
00:50  Chắp tay trước ngực, tĩnh tâm.
01:02  Thở tự nhiên, đều.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E202 · Vi Đà hiến chử — thức 2** (01:15)

```text
00:00  Thức 2: Vi Đà hiến chử — thức 2.
00:02  Nâng khuỷu ngang vai.
00:25  Mở tay sang hai bên.
00:50  Dựng cổ tay, đẩy nhẹ ra hai bên.
01:02  Hít vào khi mở tay, thở ra khi đẩy.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E203 · Vi Đà hiến chử — thức 3** (01:15)

```text
00:00  Thức 3: Vi Đà hiến chử — thức 3.
00:02  Tay ngang vai.
00:25  Lật tay, vòng lên cao.
00:50  Nâng hai tay trên đầu như đỡ vật.
01:02  Hít vào khi nâng, thở ra khi hạ.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E204 · Trích tinh hoán đẩu** (01:15)

```text
00:00  Thức 4: Trích tinh hoán đẩu.
00:02  Tay phải đưa xuống trước hông trái.
00:25  Vung tay lên, tay kia đặt sau lưng.
00:50  Bàn tay khum trên cao, mắt nhìn theo; đổi bên.
01:02  Hít vào khi vung lên, thở ra khi hạ xuống.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E205 · Đảo duệ cửu ngưu vĩ** (01:15)

```text
00:00  Thức 5: Đảo duệ cửu ngưu vĩ.
00:02  Chùng gối trước, hai tay nắm trước sau.
00:25  Dồn trọng tâm về sau, xoay eo.
00:50  Kéo như kéo đuôi trâu; đổi bên.
01:02  Thở ra khi kéo về, hít vào khi trở lại.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E206 · Xuất trảo lượng sí** (01:15)

```text
00:00  Thức 6: Xuất trảo lượng sí.
00:02  Dựng hai bàn tay trước ngực.
00:25  Đẩy chậm ra trước, xòe ngón.
00:50  Duỗi tay, xòe ngón như móng vuốt; thu về.
01:02  Thở ra khi đẩy, hít vào khi thu.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E207 · Cửu quỷ bạt mã đao** (01:15)

```text
00:00  Thức 7: Cửu quỷ bạt mã đao.
00:02  Tay vòng sau đầu, tay kia áp lưng.
00:25  Xoay thân chậm, mở khuỷu tay.
00:50  Giữ ngực mở, cổ thẳng; đổi bên.
01:02  Thở ra khi xoay, hít vào khi trở về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E208 · Tam bàn lạc địa** (01:15)

```text
00:00  Thức 8: Tam bàn lạc địa.
00:02  Chân rộng, tay ngửa trước ngực.
00:25  Chùng gối, lật tay ấn xuống.
00:50  Tay ngang gối như đặt đĩa; đứng lên nâng tay.
01:02  Thở ra khi hạ, hít vào khi đứng lên.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E209 · Thanh long thám trảo** (01:15)

```text
00:00  Thức 9: Thanh long thám trảo.
00:02  Nắm tay cạnh eo.
00:25  Vươn vuốt rồng sang trái, xoay thân.
00:50  Cúi nhẹ, vươn tay xuống, quét về; đổi bên.
01:02  Thở ra khi vươn xuống, hít vào khi đứng lên.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E210 · Ngọa hổ phác thực** (01:15)

```text
00:00  Thức 10: Ngọa hổ phác thực.
00:02  Chùng gối trước, tay vuốt hổ.
00:25  Đẩy tay ra trước và xuống.
00:50  Nghiêng người như hổ vồ, tay đặt lên gối; đổi bên.
01:02  Thở ra khi vồ xuống, hít vào khi trở về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E211 · Đả cung** (01:15)

```text
00:00  Thức 11: Đả cung.
00:02  Hai tay áp tai, ngón đặt sau gáy.
00:25  Gõ nhẹ ngón tay sau đầu.
00:50  Cúi chậm, cuộn lưng xuống, rồi cuộn lên.
01:02  Thở ra khi cúi, hít vào khi lên.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E212 · Điệu vĩ** (01:15)

```text
00:00  Thức 12: Điệu vĩ.
00:02  Đan tay đẩy ra trước.
00:25  Cúi nhẹ, tay đan đẩy xuống.
00:50  Quay đầu nhìn sau, hông lắc cùng bên; đổi bên.
01:02  Thở tự nhiên, không nín thở.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

#### Ngũ Cầm Hí

**E301 · Hổ giơ vuốt** (01:15)

```text
00:00  Thức 1: Hổ giơ vuốt.
00:02  Tay vuốt hổ trước bụng.
00:25  Nâng tay lên ngực, nắm rồi mở.
00:50  Vươn vuốt lên cao, rồi ấn xuống.
01:02  Hít vào khi nâng, thở ra khi ấn xuống.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E302 · Hổ vồ mồi** (01:15)

```text
00:00  Thức 2: Hổ vồ mồi.
00:02  Vuốt hổ ngang vai, cúi nhẹ.
00:25  Duỗi thân, vươn tay ra trước.
00:50  Bước tới, vồ xuống ngang gối; đổi bên.
01:02  Thở ra khi vồ xuống.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E303 · Hươu húc gạc** (01:15)

```text
00:00  Thức 3: Hươu húc gạc.
00:02  Tay sừng hươu cạnh eo.
00:25  Bước gót, vung tay vòng cung.
00:50  Xoay thân nhìn về gót chân; đổi bên.
01:02  Hít vào khi vung lên, thở ra khi xoay.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E304 · Hươu chạy** (01:15)

```text
00:00  Thức 4: Hươu chạy.
00:02  Chùng gối trước, tay sừng hươu ra trước.
00:25  Dồn về sau, cong lưng.
00:50  Lưng cong như cung, rồi trở về; đổi chân.
01:02  Thở ra khi cong lưng, hít vào khi trở về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E305 · Gấu lắc mình** (01:15)

```text
00:00  Thức 5: Gấu lắc mình.
00:02  Tay chân gấu trước bụng.
00:25  Nhấc hông, bước chân phải.
00:50  Dồn trọng tâm, thân lắc nhẹ; đổi bên.
01:02  Thở tự nhiên theo nhịp bước.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E306 · Gấu xoa bụng** (01:15)

```text
00:00  Thức 6: Gấu xoa bụng.
00:02  Tay chân gấu trước rốn.
00:25  Xoay eo, tay vẽ vòng quanh rốn.
00:50  Hoàn tất vòng, đổi chiều.
01:02  Hít vào nửa vòng lên, thở ra nửa vòng xuống.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E307 · Khỉ cảnh giác** (01:15)

```text
00:00  Thức 7: Khỉ cảnh giác.
00:02  Tay móc khỉ trước bụng.
00:25  Nhún vai, nâng tay, kiễng gót nhẹ.
00:50  Quay đầu cảnh giác, rồi hạ xuống; đổi bên.
01:02  Hít vào khi nâng, thở ra khi hạ.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E308 · Khỉ hái quả** (01:15)

```text
00:00  Thức 8: Khỉ hái quả.
00:02  Lùi nhẹ, tay móc khỉ.
00:25  Vươn tay hái quả trên cao.
00:50  Mang quả về ngực, tay kia đỡ; đổi bên.
01:02  Hít vào khi vươn lên, thở ra khi thu về.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E309 · Chim vươn cánh** (01:15)

```text
00:00  Thức 9: Chim vươn cánh.
00:02  Hai tay chồng trước bụng.
00:25  Nâng tay lên cao, mở ngực.
00:50  Mở tay ra sau như cánh; đổi bên.
01:02  Hít vào khi nâng, thở ra khi mở cánh.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E310 · Chim bay** (01:15)

```text
00:00  Thức 10: Chim bay.
00:02  Tay trước bụng, gối chùng.
00:25  Dang tay như cánh chim.
00:50  Tay lên cao rồi hạ; đổi chân.
01:02  Hít vào khi dang cánh, thở ra khi hạ.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

#### Lục Tự Quyết

**E401 · Âm Xu (嘘)** (01:15)

```text
00:00  Thức 1: Âm Xu (嘘).
00:02  Hai tay ngửa cạnh eo.
00:25  Xoay thân, đẩy tay ra, mắt mở to.
00:50  Thở ra đọc nhẹ "xū"; đổi bên.
01:02  Hít vào bằng mũi tự nhiên; thở ra chậm khi phát âm, không cố đẩy hết hơi.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E402 · Âm He (呵)** (01:15)

```text
00:00  Thức 2: Âm He (呵).
00:02  Tay như vốc nước trước bụng.
00:25  Vốc tay lên ngực.
00:50  Lật tay ấn xuống, thở ra đọc "hē".
01:02  Hít vào khi nâng, thở ra khi phát âm.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E403 · Âm Hu (呼)** (01:15)

```text
00:00  Thức 3: Âm Hu (呼).
00:02  Tay trước rốn.
00:25  Mở tay ra hai bên.
00:50  Thở ra đọc "hū", thu tay về.
01:02  Hít vào khi thu, thở ra khi mở và phát âm.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E404 · Âm Si (呬)** (01:15)

```text
00:00  Thức 4: Âm Si (呬).
00:02  Tay trước ngực, đầu ngón hướng nhau.
00:25  Kéo vai ra sau, mở ngực.
00:50  Đẩy tay ra trước, thở ra đọc "sī".
01:02  Hít vào khi mở ngực, thở ra khi đẩy và phát âm.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E405 · Âm Chui (吹)** (01:15)

```text
00:00  Thức 5: Âm Chui (吹).
00:02  Tay đặt sau thắt lưng.
00:25  Vuốt xuống hông, vòng ra trước.
00:50  Chùng gối, ôm vòng, thở ra đọc "chuī".
01:02  Thở ra khi hạ và phát âm, hít vào khi đứng lên.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E406 · Âm Xi (嘻)** (01:15)

```text
00:00  Thức 6: Âm Xi (嘻).
00:02  Mu bàn tay áp nhau trước bụng.
00:25  Nâng lên ngực, tách ra lên cao.
00:50  Hạ tay sang hai bên, thở ra đọc "xī".
01:02  Hít vào khi nâng, thở ra khi hạ và phát âm.
01:10  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

#### Thái Cực Quyền 24 thức

**E501 · Khởi thế** (00:55)

```text
00:00  Thức 1: Khởi thế.
00:02  Đứng khép chân.
00:18  Bước rộng vai, nâng tay ngang vai.
00:36  Chùng gối, ấn tay xuống.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E502 · Dã mã phân tông** (00:55)

```text
00:00  Thức 2: Dã mã phân tông.
00:02  Ôm bóng bên phải.
00:18  Bước tới, chuyển trọng tâm.
00:36  Tách tay: trước cao, sau thấp.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E503 · Bạch hạc lượng sí** (00:55)

```text
00:00  Thức 3: Bạch hạc lượng sí.
00:02  Theo nửa bước.
00:18  Hư bộ, mũi chân trái chạm đất.
00:36  Tay phải cạnh trán, tay trái cạnh hông.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E504 · Lâu tất ảo bộ** (00:55)

```text
00:00  Thức 4: Lâu tất ảo bộ.
00:02  Tay phải cạnh tai.
00:18  Bước cung bộ trái.
00:36  Tay trái quét gối, tay phải đẩy ra.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E505 · Thủ huy tỳ bà** (00:55)

```text
00:00  Thức 5: Thủ huy tỳ bà.
00:02  Theo nửa bước, dồn sau.
00:18  Gót trái chạm trước.
00:36  Hai tay như ôm đàn.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E506 · Đảo quyển quăng** (00:55)

```text
00:00  Thức 6: Đảo quyển quăng.
00:02  Tay phải vòng lên tai.
00:18  Lùi chân trái.
00:36  Đẩy tay phải, rút tay trái.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E507 · Tả lãm tước vĩ** (00:55)

```text
00:00  Thức 7: Tả lãm tước vĩ.
00:02  Ôm bóng, bước trái.
00:18  Bằng rồi lý: đưa ra, kéo về.
00:36  Tễ rồi án: ép và đẩy ra.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E508 · Hữu lãm tước vĩ** (00:55)

```text
00:00  Thức 8: Hữu lãm tước vĩ.
00:02  Ôm bóng, bước phải.
00:18  Đưa ra, kéo về.
00:36  Ép và đẩy ra.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E509 · Đơn tiên** (00:55)

```text
00:00  Thức 9: Đơn tiên.
00:02  Tay phải thành móc.
00:18  Bước trái, chuyển trọng tâm.
00:36  Tay trái đẩy ra, móc phải giữ sau.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E510 · Vân thủ** (00:55)

```text
00:00  Thức 10: Vân thủ.
00:02  Tay ngang ngực và bụng.
00:18  Bước ngang, tay vẽ vòng như mây.
00:36  Khép chân, kết thúc vòng.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E511 · Đơn tiên (lặp)** (00:55)

```text
00:00  Thức 11: Đơn tiên (lặp).
00:02  Tay phải thành móc.
00:18  Bước trái.
00:36  Đẩy tay trái ra.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E512 · Cao thám mã** (00:55)

```text
00:00  Thức 12: Cao thám mã.
00:02  Theo nửa bước.
00:18  Hư bộ trái.
00:36  Tay phải đẩy cao, tay trái ngửa.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E513 · Hữu đăng cước** (00:55)

```text
00:00  Thức 13: Hữu đăng cước.
00:02  Bắt chéo tay, đứng chân trái.
00:18  Nhấc gối phải.
00:36  Duỗi gót thấp, mở tay.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E514 · Song phong quán nhĩ** (00:55)

```text
00:00  Thức 14: Song phong quán nhĩ.
00:02  Hạ tay cạnh gối.
00:18  Bước cung bộ phải.
00:36  Hai nắm tay vòng lên trước.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E515 · Chuyển thân tả đăng cước** (00:55)

```text
00:00  Thức 15: Chuyển thân tả đăng cước.
00:02  Xoay thân, bắt chéo tay.
00:18  Nhấc gối trái.
00:36  Duỗi gót thấp, mở tay.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E516 · Tả hạ thế độc lập** (00:55)

```text
00:00  Thức 16: Tả hạ thế độc lập.
00:02  Tay móc, tay kia trước ngực.
00:18  Duỗi chân trái, tay vuốt theo (không hạ sâu).
00:36  Đứng lên chân trái, nhấc gối nhẹ.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E517 · Hữu hạ thế độc lập** (00:55)

```text
00:00  Thức 17: Hữu hạ thế độc lập.
00:02  Tay móc, tay kia trước ngực.
00:18  Duỗi chân phải, tay vuốt theo.
00:36  Đứng lên chân phải, nhấc gối nhẹ.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E518 · Tả hữu xuyên thoa** (00:55)

```text
00:00  Thức 18: Tả hữu xuyên thoa.
00:02  Ôm bóng, bước trái.
00:18  Tay trái nâng chặn trên trán.
00:36  Tay phải đẩy ra; đổi bên.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E519 · Hải để châm** (00:55)

```text
00:00  Thức 19: Hải để châm.
00:02  Theo nửa bước.
00:18  Hư bộ trái.
00:36  Tay phải cắm xuống, nghiêng nhẹ.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E520 · Thiểm thông tý** (00:55)

```text
00:00  Thức 20: Thiểm thông tý.
00:02  Hai tay trước ngực.
00:18  Bước cung bộ trái.
00:36  Tay phải trên trán, tay trái đẩy ra.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E521 · Chuyển thân ban lan chùy** (00:55)

```text
00:00  Thức 21: Chuyển thân ban lan chùy.
00:02  Xoay phải, nắm tay trước bụng.
00:18  Quét và chặn, bước trái.
00:36  Đấm ra ngang ngực.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E522 · Như phong tự bế** (00:55)

```text
00:00  Thức 22: Như phong tự bế.
00:02  Tay trái luồn dưới tay phải.
00:18  Kéo hai tay về ngực.
00:36  Đẩy hai tay ra trước.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E523 · Thập tự thủ** (00:55)

```text
00:00  Thức 23: Thập tự thủ.
00:02  Xoay phải, tách tay.
00:18  Tay vòng xuống, chân song song.
00:36  Bắt chéo tay trước ngực.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

**E524 · Thu thế** (00:55)

```text
00:00  Thức 24: Thu thế.
00:02  Tay chéo trước ngực.
00:18  Lật tay úp, tách rộng vai.
00:36  Hạ tay, khép chân, đứng tĩnh.
00:45  Thở tự nhiên, nhẹ và đều theo chuyển động.
00:50  Tập trong phạm vi thoải mái; dừng nếu chóng mặt hay đau.
```

---

## 5. Âm báo (4 file)

**Yêu cầu chung:**
- ≤ 1 giây, 48 kHz, xuất OGG + M4A, −18 LUFS.
- Nghe rõ cách 2 m ngoài trời nhưng không giật mình; dải tần chính 500 Hz–3 kHz, không chói trên 6 kHz.
- Cùng một "họ âm" (cùng nhạc cụ) để người tập nhận ra.

| Tên file | Khi phát | Prompt cho công cụ tạo âm thanh |
|---|---|---|
| `cue_step_soon` | Còn 10 s của động tác (đồng bộ cảnh báo hổ phách ở chế độ xem từ xa) | "Two soft wooden chime notes, gentle descending interval, warm, calm, 0.8 seconds, no reverb tail longer than 0.5 s" |
| `cue_step_start` | Bắt đầu động tác mới | "Single clear singing-bowl strike, soft attack, warm overtones, decays within 1 second, calm and inviting" |
| `cue_countdown` | Mỗi giây 3-2-1 | "Short soft wooden tick, muted, 0.15 seconds, gentle" |
| `cue_complete` | Hoàn thành bài | "Three ascending soft chime notes in a pentatonic scale, warm and peaceful, 1.5 seconds" |

---

## 6. Nhạc nền (6 bản)

**Yêu cầu chung cho mọi bản:**
- Không lời; vòng lặp liền mạch 2–3 phút; 48 kHz stereo; −23 LUFS (nhạc nền).
- Không đổi nhịp hay cao trào đột ngột.
- Chừa dải giọng nói 1–4 kHz: giai điệu thưa, nhạc cụ trầm ấm.
- Khi có giọng đọc, app hạ nhạc thêm 10–12 dB (ducking).
- Có giấy phép dùng thương mại trong ứng dụng.

| Mã | Dùng cho | Tempo | Prompt cho công cụ tạo nhạc |
|---|---|---:|---|
| M1 `music_morning` | R01–R04, bộ cơ bản | 60–66 BPM | "Gentle Vietnamese-inspired morning meditation music, đàn tranh (zither) and bamboo flute (sáo trúc) over a soft warm pad, D major pentatonic, sparse melody, calm and hopeful, seamless loop, no vocals, no drums" |
| M2 `music_evening` | R05, chế độ xem từ xa buổi tối | 50–56 BPM | "Warm evening relaxation ambient, low soft pads, occasional distant singing bowl, very sparse low-register piano, no high frequencies, sleepy and safe, seamless loop, no vocals, no percussion" |
| M3 `music_qigong` | Bát Đoạn Cẩm, Dịch Cân Kinh | 56–60 BPM | "Traditional East Asian qigong practice music, guqin and xiao flute with soft drone, slow breathing phrases of 8 seconds, serene mountain atmosphere, seamless loop, no vocals" |
| M4 `music_five_animals` | Ngũ Cầm Hí | 66–72 BPM | "Light playful East Asian nature music, pipa plucks and bamboo flute, very soft wooden percussion, gentle forest ambience, cheerful but calm, seamless loop, no vocals" |
| M5 `music_six_sounds` | Lục Tự Quyết | không nhịp | "Minimal ambient drone, single warm low tone with slow gentle swells, almost silent, leaves full space for spoken breathing sounds, seamless loop, no melody, no vocals" (nên mặc định **tắt** nhạc cho hệ này) |
| M6 `music_taichi` | Thái Cực 24 thức | 52–58 BPM | "Flowing tai chi music, guqin and erhu long sustained phrases over soft pad, continuous like water, no sudden changes, seamless loop, no vocals, no drums" |

**Prompt cho ChatGPT** (khi cần biến tấu hoặc chuyển sang công cụ khác):

```text
Viết mô tả chi tiết (bằng tiếng Anh, ≤ 60 từ) cho công cụ tạo nhạc AI để tạo nhạc nền
dưỡng sinh: {mục đích}, tempo {BPM}, nhạc cụ {…}, cảm xúc {…}. Yêu cầu: không lời,
lặp liền mạch, không trống mạnh, chừa dải tần giọng nói. Đưa 3 phương án khác nhau.
```

---

## 7. Checklist trước khi nhận một file

**Ảnh:**
- [ ] Đúng mã và khe, đúng tư thế mô tả.
- [ ] Toàn thân trong khung; 5 ngón mỗi bàn tay; khớp đúng hướng.
- [ ] Cùng nhân vật, trang phục, bối cảnh với các khung còn lại của thức.
- [ ] Không chữ hay watermark; biên độ không quá mức; với các thức có rủi ro thì có bản `_chair`.

**Giọng đọc:**
- [ ] Đúng kịch bản và mốc thời gian (±0.5 s).
- [ ] Phát âm Lục Tự Quyết đã được chuyên gia nghe duyệt.
- [ ] Không tiếng ồn, không méo.

**Âm báo / nhạc:**
- [ ] Đúng thời lượng và độ lớn.
- [ ] Lặp liền mạch.
- [ ] Có giấy phép thương mại.

**Hồ sơ:**
- [ ] Dòng trong `media_manifest.csv` có công cụ, ai tạo, `ai_generated`, giấy phép, người duyệt, ngày duyệt.

---

## 8. Phần app cần làm để dùng được media này

- **Ảnh tư thế mới:**
  - E01–E07: dùng ngay sau khi thay file và chạy lại script catalog.
  - Phương Đông: cần T16 (đưa thức vào catalog chính với 3 bước, cổng xuất bản).
- **Giọng đọc, âm báo, nhạc nền:** app **chưa phát âm thanh**. Cần T06:
  - adapter audio;
  - phát âm báo đồng bộ với cảnh báo 10 giây cuối;
  - nhạc nền có ducking;
  - công tắc "Giọng đọc" và "Nhạc nền" trong Cài đặt;
  - tạm dừng khi mất audio focus (PRD F03).
