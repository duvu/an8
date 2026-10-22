// Traditional almanac tables (lịch vạn niên). Reference material from
// Vietnamese tradition, not advice; see DECISIONS D26 for the sources and the
// day-level checks the rules were verified against.

/// 24 tiết khí; index = floor(sun longitude / 15°), so 0 is 0° (Xuân phân).
const solarTermNames = [
  'Xuân phân', 'Thanh minh', 'Cốc vũ', 'Lập hạ', 'Tiểu mãn', 'Mang chủng', //
  'Hạ chí', 'Tiểu thử', 'Đại thử', 'Lập thu', 'Xử thử', 'Bạch lộ', //
  'Thu phân', 'Hàn lộ', 'Sương giáng', 'Lập đông', 'Tiểu tuyết', 'Đại tuyết', //
  'Đông chí', 'Tiểu hàn', 'Đại hàn', 'Lập xuân', 'Vũ thủy', 'Kinh trập',
];

/// 12 trực in order, starting from Kiến (the day whose chi equals the month's).
const trucNames = [
  'Kiến', 'Trừ', 'Mãn', 'Bình', 'Định', 'Chấp', //
  'Phá', 'Nguy', 'Thành', 'Thu', 'Khai', 'Bế',
];

enum TrucLevel { good, neutral, bad }

typedef TrucInfo = ({TrucLevel level, String note});

/// Short reading of each trực. Only well-attested uses are listed.
const trucInfo = <TrucInfo>[
  (
    level: TrucLevel.neutral,
    note: 'Tốt cho xuất hành, giá thú; tránh động thổ.',
  ),
  (
    level: TrucLevel.neutral,
    note: 'Hợp chữa bệnh, dọn dẹp, bỏ cái cũ; tránh cưới hỏi, khai trương, động thổ.',
  ),
  (level: TrucLevel.good, note: 'Hợp cầu tài, cầu phúc, cúng tế.'),
  (
    level: TrucLevel.neutral,
    note: 'Ngày trung bình, không đặc biệt tốt hay xấu.',
  ),
  (
    level: TrucLevel.good,
    note:
        'Hợp cầu tài, ký kết hợp đồng, yến tiệc; tránh kiện tụng, tranh chấp.',
  ),
  (
    level: TrucLevel.neutral,
    note: 'Ngày trung bình, nên làm việc quen thuộc, ổn định.',
  ),
  (
    level: TrucLevel.bad,
    note: 'Ngày xấu cho hầu hết việc quan trọng; chỉ hợp phá dỡ cái cũ.',
  ),
  (level: TrucLevel.bad, note: 'Ngày xấu, nên thận trọng, tránh việc lớn.'),
  (
    level: TrucLevel.good,
    note: 'Ngày tốt, hợp khởi sự, khai trương, cưới hỏi, xây dựng.',
  ),
  (level: TrucLevel.good, note: 'Hợp thu hoạch, thu nợ, cất giữ.'),
  (
    level: TrucLevel.good,
    note: 'Ngày tốt để mở đầu việc mới: khai trương, khởi công, cưới hỏi.',
  ),
  (
    level: TrucLevel.bad,
    note: 'Ngày xấu cho hầu hết việc; chỉ hợp lấp hố, mương, cống.',
  ),
];

/// The 12 thần of the day/hour cycle, in order from Thanh Long.
const twelveGods = [
  'Thanh Long', 'Minh Đường', 'Thiên Hình', 'Chu Tước', 'Kim Quỹ', //
  'Bảo Quang', 'Bạch Hổ', 'Ngọc Đường', 'Thiên Lao', 'Huyền Vũ', //
  'Tư Mệnh', 'Câu Trần',
];

/// Offsets (from Thanh Long) of the six hoàng đạo gods: Thanh Long, Minh
/// Đường, Kim Quỹ, Bảo Quang, Ngọc Đường, Tư Mệnh.
const hoangDaoOffsets = {0, 1, 4, 5, 7, 10};

/// Lục diệu in cycle order: Khổng Minh (by lunar date) for the day, Lý Thuần
/// Phong (fixed by hour) for the hours.
enum LucDieuLevel { good, bad }

typedef LucDieuInfo = ({String name, LucDieuLevel level, String note});

const lucDieu = <LucDieuInfo>[
  (
    name: 'Đại An',
    level: LucDieuLevel.good,
    note: 'Mọi việc đều tốt lành, yên ổn.',
  ),
  (
    name: 'Lưu Liên',
    level: LucDieuLevel.bad,
    note: 'Việc khó thành, chậm trễ; chuyện kiện tụng nên hoãn.',
  ),
  (
    name: 'Tốc Hỷ',
    level: LucDieuLevel.good,
    note: 'Ngày khá tốt, tin vui đến nhanh; nên làm việc sớm trong ngày.',
  ),
  (
    name: 'Xích Khẩu',
    level: LucDieuLevel.bad,
    note: 'Dễ cãi vã, thị phi; nên giữ lời, hoãn việc quan trọng.',
  ),
  (
    name: 'Tiểu Cát',
    level: LucDieuLevel.good,
    note: 'Rất tốt lành, đi thì gặp may, buôn bán có lời.',
  ),
  (
    name: 'Không Vong',
    level: LucDieuLevel.bad,
    note: 'Nên cẩn trọng, làm từng bước; hạn chế việc lớn và đi xa.',
  ),
];

/// Hỷ thần (hướng tốt cầu may) by day stem, Giáp = 0.
const hyThanByCan = [
  'Đông Bắc', 'Tây Bắc', 'Tây Nam', 'Nam', 'Đông Nam', //
  'Đông Bắc', 'Tây Bắc', 'Tây Nam', 'Nam', 'Đông Nam',
];

/// Tài thần (hướng cầu tài) by day stem, Giáp = 0.
const taiThanByCan = [
  'Đông Nam', 'Đông Nam', 'Đông', 'Đông', 'Bắc', //
  'Nam', 'Tây Nam', 'Tây Nam', 'Tây', 'Tây Bắc',
];
