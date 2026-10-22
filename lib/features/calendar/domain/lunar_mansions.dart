import 'lunar_calendar.dart';

// Nhị thập bát tú: the 28 lunar mansions. One mansion rules each day, in an
// unbroken 28-day cycle. Names, elements, animals, classes and the "nên làm" /
// "kiêng cữ" texts follow a printed Vietnamese almanac (quantrimang.com/
// lich-am, 28 consecutive days from 22/10/2025); see DECISIONS D26/D27.

/// Kiết tú (tốt), bình tú (trung bình), hung tú (xấu).
enum MansionLevel { kiet, binh, hung }

final class LunarMansion {
  const LunarMansion({
    required this.name,
    required this.element,
    required this.animal,
    required this.level,
    required this.favorable,
    required this.avoid,
  });

  final String name;
  final String element;
  final String animal;
  final MansionLevel level;

  /// "Nên làm".
  final String favorable;

  /// "Kiêng cữ".
  final String avoid;
}

/// Order of the cycle, Giác first. Giác falls on a Thursday (Mộc), and each
/// element group repeats weekly: Mộc Thu, Kim Fri, Thổ Sat, Nhật Sun, Nguyệt
/// Mon, Hỏa Tue, Thủy Wed.
const lunarMansions = <LunarMansion>[
  LunarMansion(
    name: 'Giác',
    element: 'Mộc',
    animal: 'Giao (thuồng luồng)',
    level: MansionLevel.binh,
    favorable: 'Tạo tác mọi việc đều đặng vinh xương, tấn lợi; hôn nhân cưới gả sinh con quý; công danh khoa cử đỗ đạt cao.',
    avoid: 'Chôn cất hoạn nạn ba năm; sửa chữa hay xây đắp mộ phần ắt có người chết.',
  ),
  LunarMansion(
    name: 'Cang',
    element: 'Kim',
    animal: 'Long (rồng)',
    level: MansionLevel.hung,
    favorable: 'Cắt may áo màn (sẽ có lộc ăn).',
    avoid: 'Chôn cất bị trùng tang; cưới gả e phòng không giá lạnh; tranh đấu kiện tụng lâm bại; khởi dựng nhà cửa thì con đầu dễ gặp nạn.',
  ),
  LunarMansion(
    name: 'Đê',
    element: 'Thổ',
    animal: 'Lạc (lạc đà)',
    level: MansionLevel.hung,
    favorable: 'Không có việc nào hợp với ngày này.',
    avoid: 'Đại kỵ khởi công xây dựng, chôn cất, cưới gả; xuất hành kỵ nhất là đường thủy.',
  ),
  LunarMansion(
    name: 'Phòng',
    element: 'Thái dương',
    animal: 'Thố (thỏ)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công tạo tác mọi việc đều tốt, nhất là xây dựng nhà, chôn cất, cưới gả, xuất hành, đi thuyền, mưu sự, cắt áo.',
    avoid: 'Đại kiết tinh, không kỵ việc gì cả.',
  ),
  LunarMansion(
    name: 'Tâm',
    element: 'Thái âm',
    animal: 'Hồ (chồn)',
    level: MansionLevel.hung,
    favorable: 'Làm việc gì cũng không hợp với sao hung tú này.',
    avoid: 'Khởi công tạo tác việc gì cũng không khỏi hại, nhất là xây cất, cưới gả, chôn cất, đóng giường, lót giường, tranh tụng.',
  ),
  LunarMansion(
    name: 'Vĩ',
    element: 'Hỏa',
    animal: 'Hổ (cọp)',
    level: MansionLevel.kiet,
    favorable: 'Mọi việc đều tốt, tốt nhất là các việc khởi tạo, chôn cất, cưới gả, xây cất.',
    avoid: 'Đóng giường, lót giường, đi thuyền.',
  ),
  LunarMansion(
    name: 'Cơ',
    element: 'Thủy',
    animal: 'Báo (beo)',
    level: MansionLevel.kiet,
    favorable: 'Khởi tạo trăm việc đều tốt, tốt nhất là chôn cất, tu bổ mồ mả, trổ cửa, khai trương, xuất hành.',
    avoid: 'Đóng giường, lót giường, đi thuyền.',
  ),
  LunarMansion(
    name: 'Đẩu',
    element: 'Mộc',
    animal: 'Giải (cua)',
    level: MansionLevel.kiet,
    favorable:
        'Khởi tạo trăm việc đều tốt, tốt nhất là xây đắp hay sửa chữa phần mộ.',
    avoid: 'Rất kỵ đi thuyền.',
  ),
  LunarMansion(
    name: 'Ngưu',
    element: 'Kim',
    animal: 'Ngưu (trâu)',
    level: MansionLevel.hung,
    favorable: 'Đi thuyền, may áo.',
    avoid: 'Khởi công tạo tác việc gì cũng hung hại, nhất là xây cất nhà, dựng trại, cưới gả, trổ cửa.',
  ),
  LunarMansion(
    name: 'Nữ',
    element: 'Thổ',
    animal: 'Bức (dơi)',
    level: MansionLevel.hung,
    favorable: 'Kết màn, may áo.',
    avoid: 'Khởi công tạo tác trăm việc đều có hại, xấu nhất là trổ cửa, khơi đường tháo nước, chôn cất, đầu đơn kiện cáo.',
  ),
  LunarMansion(
    name: 'Hư',
    element: 'Thái dương',
    animal: 'Thử (chuột)',
    level: MansionLevel.hung,
    favorable: 'Không có việc gì hợp với ngày có sao Hư.',
    avoid: 'Khởi công tạo tác trăm việc đều không may, nhất là xây cất nhà cửa, cưới gả, khai trương, trổ cửa, tháo nước, đào kênh rạch.',
  ),
  LunarMansion(
    name: 'Nguy',
    element: 'Thái âm',
    animal: 'Yến (chim én)',
    level: MansionLevel.hung,
    favorable: 'Chôn cất rất tốt, lót giường bình yên.',
    avoid: 'Dựng nhà, trổ cửa, tháo nước, đào mương rạch, đi thuyền.',
  ),
  LunarMansion(
    name: 'Thất',
    element: 'Hỏa',
    animal: 'Trư (heo)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công trăm việc đều tốt, tốt nhất là xây cất nhà cửa, cưới gả, chôn cất, trổ cửa, tháo nước, các việc thủy lợi, đi thuyền.',
    avoid: 'Đại kiết, không có việc gì phải kiêng cữ.',
  ),
  LunarMansion(
    name: 'Bích',
    element: 'Thủy',
    animal: 'Du (rái cá)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công tạo tác việc gì cũng tốt, tốt nhất là xây cất nhà, cưới gả, chôn cất, trổ cửa, tháo nước, khai trương, xuất hành.',
    avoid: 'Toàn kiết, không có việc gì phải kiêng cữ; gặp ngày Hợi, Mão, Mùi thì trăm việc đều kỵ, nhất là mùa đông.',
  ),
  LunarMansion(
    name: 'Khuê',
    element: 'Mộc',
    animal: 'Lang (sói)',
    level: MansionLevel.binh,
    favorable: 'Tạo dựng nhà phòng, nhập học, ra đi cầu công danh, cắt áo.',
    avoid: 'Chôn cất, khai trương, trổ cửa dựng cửa, khai thông đường nước, đào ao móc giếng, thưa kiện, đóng giường lót giường.',
  ),
  LunarMansion(
    name: 'Lâu',
    element: 'Kim',
    animal: 'Cẩu (chó)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công mọi việc đều tốt, tốt nhất là dựng cột, cất lầu, làm dàn gác, cưới gả, trổ cửa, tháo nước.',
    avoid: 'Đóng giường, lót giường, đi đường thủy.',
  ),
  LunarMansion(
    name: 'Vị',
    element: 'Thổ',
    animal: 'Trĩ (chim trĩ)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công tạo tác việc gì cũng lợi, tốt nhất là xây cất, cưới gả, chôn cất, dọn cỏ phá đất, gieo trồng, lấy giống.',
    avoid: 'Đi thuyền.',
  ),
  LunarMansion(
    name: 'Mão',
    element: 'Thái dương',
    animal: 'Kê (gà)',
    level: MansionLevel.hung,
    favorable: 'Xây dựng, tạo tác.',
    avoid: 'Chôn cất (đại kỵ), cưới gả, trổ cửa dựng cửa, khai ngòi phóng thủy, khai trương, xuất hành, đóng giường lót giường.',
  ),
  LunarMansion(
    name: 'Tất',
    element: 'Thái âm',
    animal: 'Ô (quạ)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công tạo tác việc gì cũng tốt, tốt nhất là chôn cất, cưới gả, trổ cửa dựng cửa, đào kênh, tháo nước, khai mương, móc giếng; cũng tốt: làm ruộng, nuôi tằm, khai trương, xuất hành, nhập học.',
    avoid: 'Đi thuyền.',
  ),
  LunarMansion(
    name: 'Chủy',
    element: 'Hỏa',
    animal: 'Hầu (khỉ)',
    level: MansionLevel.hung,
    favorable: 'Không có việc gì hợp với sao Chủy.',
    avoid: 'Khởi công tạo tác việc gì cũng không tốt; kỵ nhất là chôn cất, sửa đắp mồ mả, đóng thọ đường.',
  ),
  LunarMansion(
    name: 'Sâm',
    element: 'Thủy',
    animal: 'Viên (vượn)',
    level: MansionLevel.binh,
    favorable: 'Khởi công tạo tác nhiều việc tốt: xây cất nhà, dựng cửa trổ cửa, nhập học, đi thuyền, làm thủy lợi, tháo nước đào mương.',
    avoid: 'Cưới gả, chôn cất, đóng giường lót giường, kết bạn.',
  ),
  LunarMansion(
    name: 'Tỉnh',
    element: 'Mộc',
    animal: 'Hãn (dê trừu)',
    level: MansionLevel.binh,
    favorable: 'Tạo tác nhiều việc tốt như xây cất, trổ cửa dựng cửa, mở thông đường nước, đào mương móc giếng; hợp nhận chức vụ, theo học, đi thuyền.',
    avoid: 'Chôn cất, tu bổ phần mộ, đóng thọ đường.',
  ),
  LunarMansion(
    name: 'Quỷ',
    element: 'Kim',
    animal: 'Dương (dê)',
    level: MansionLevel.hung,
    favorable: 'Chôn cất, cắt áo.',
    avoid: 'Khởi tạo việc gì cũng xấu, nhất là xây cất nhà, cưới gả, trổ cửa dựng cửa, tháo nước, đào ao giếng.',
  ),
  LunarMansion(
    name: 'Liễu',
    element: 'Thổ',
    animal: 'Chương (gấu ngựa)',
    level: MansionLevel.hung,
    favorable: 'Không có việc gì hợp với sao Liễu.',
    avoid: 'Khởi công tạo tác việc gì cũng hung hại, nhất là chôn cất, xây đắp, trổ cửa dựng cửa.',
  ),
  LunarMansion(
    name: 'Tinh',
    element: 'Thái dương',
    animal: 'Mã (ngựa)',
    level: MansionLevel.binh,
    favorable: 'Xây dựng phòng mới.',
    avoid: 'Chôn cất, cưới gả, mở thông đường nước.',
  ),
  LunarMansion(
    name: 'Trương',
    element: 'Thái âm',
    animal: 'Lộc (nai)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công tạo tác trăm việc đều tốt, tốt nhất là xây cất nhà, che mái dựng hiên; cũng hợp cưới gả, chôn cất, làm ruộng, nuôi tằm, may cắt áo, làm thủy lợi.',
    avoid: 'Sửa hoặc làm thuyền chèo, đẩy thuyền mới xuống nước.',
  ),
  LunarMansion(
    name: 'Dực',
    element: 'Hỏa',
    animal: 'Xà (rắn)',
    level: MansionLevel.hung,
    favorable: 'Cắt áo sẽ được tiền tài.',
    avoid:
        'Chôn cất, cưới gả, xây cất nhà, trổ cửa gắn cửa, các việc thủy lợi.',
  ),
  LunarMansion(
    name: 'Chẩn',
    element: 'Thủy',
    animal: 'Dẫn (giun)',
    level: MansionLevel.kiet,
    favorable: 'Khởi công tạo tác mọi việc đều tốt lành, tốt nhất là xây cất lầu gác, chôn cất, cưới gả; cũng tốt: dựng phòng, cất trại, xuất hành.',
    avoid: 'Đi thuyền.',
  ),
];

/// Anchor of the unbroken cycle: 22 Oct 2025 is a Cơ day (index 6).
final _anchorJd = julianDayNumber(2025, 10, 22);

/// Index into [lunarMansions] of the mansion ruling the day [julianDay].
int mansionIndexFor(int julianDay) =>
    (((julianDay - _anchorJd + 6) % 28) + 28) % 28;
