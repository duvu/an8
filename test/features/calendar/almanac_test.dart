import 'package:an_nhien/features/calendar/domain/almanac_tables.dart';
import 'package:an_nhien/features/calendar/domain/day_almanac.dart';
import 'package:an_nhien/features/calendar/domain/lunar_calendar.dart';
import 'package:an_nhien/features/calendar/domain/lunar_mansions.dart';
import 'package:an_nhien/features/calendar/domain/sexagenary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LunarDate lunar(int y, int m, int d) => solarToLunar(DateTime(y, m, d));

  group('solar to lunar', () {
    test('Tết days are 1/1 of the right year', () {
      expect(
        lunar(2023, 1, 22),
        const LunarDate(day: 1, month: 1, year: 2023, isLeapMonth: false),
      );
      expect(
        lunar(2024, 2, 10),
        const LunarDate(day: 1, month: 1, year: 2024, isLeapMonth: false),
      );
      expect(
        lunar(2025, 1, 29),
        const LunarDate(day: 1, month: 1, year: 2025, isLeapMonth: false),
      );
      expect(
        lunar(2026, 2, 17),
        const LunarDate(day: 1, month: 1, year: 2026, isLeapMonth: false),
      );
    });

    test('the day before Tết is the last day of the old year', () {
      final eve = lunar(2024, 2, 9);
      expect(eve.month, 12);
      expect(eve.year, 2023);
      expect(eve.day, anyOf(29, 30));
    });

    test('leap month 2 of 2023 starts on 22 March', () {
      expect(
        lunar(2023, 3, 21),
        const LunarDate(day: 30, month: 2, year: 2023, isLeapMonth: false),
      );
      expect(
        lunar(2023, 3, 22),
        const LunarDate(day: 1, month: 2, year: 2023, isLeapMonth: true),
      );
    });

    test('Mid-Autumn 2025 is 15/8', () {
      expect(
        lunar(2025, 10, 6),
        const LunarDate(day: 15, month: 8, year: 2025, isLeapMonth: false),
      );
    });

    test('year 2000 starts inside the lunar year 1999', () {
      expect(
        lunar(2000, 1, 1),
        const LunarDate(day: 25, month: 11, year: 1999, isLeapMonth: false),
      );
    });
  });

  group('can chi', () {
    test('1 January 2000 is a Mậu Ngọ day', () {
      expect(dayCanChi(julianDayNumber(2000, 1, 1)).name, 'Mậu Ngọ');
    });

    test('years and months', () {
      expect(yearCanChi(2025).name, 'Ất Tỵ');
      expect(yearCanChi(2024).name, 'Giáp Thìn');
      expect(yearCanChi(1984).name, 'Giáp Tý');
      // Ất year: month 1 is Mậu Dần, month 9 Bính Tuất.
      expect(monthCanChi(1, 1).name, 'Mậu Dần');
      expect(monthCanChi(1, 9).name, 'Bính Tuất');
    });
  });

  // Reference days from a printed Vietnamese almanac (quantrimang.com/lich-am,
  // read 2025-10-22): lunar date, day can chi, trực, giờ hoàng đạo, hướng
  // hỷ thần / tài thần.
  group('reference days 22–31 Oct 2025', () {
    final days = <(int, String, int, String, String, String, String)>[
      (
        22,
        'Giáp Tý',
        2,
        'Mãn',
        'Tý Sửu Mão Ngọ Thân Dậu',
        'Đông Bắc',
        'Đông Nam',
      ),
      (
        23,
        'Ất Sửu',
        3,
        'Bình',
        'Dần Mão Tỵ Thân Tuất Hợi',
        'Tây Bắc',
        'Đông Nam',
      ),
      (24, 'Bính Dần', 4, 'Định', 'Tý Sửu Thìn Tỵ Mùi Tuất', 'Tây Nam', 'Đông'),
      (25, 'Đinh Mão', 5, 'Chấp', 'Tý Dần Mão Ngọ Mùi Dậu', 'Nam', 'Đông'),
      (26, 'Mậu Thìn', 6, 'Phá', 'Dần Thìn Tỵ Thân Dậu Hợi', 'Đông Nam', 'Bắc'),
      (27, 'Kỷ Tỵ', 7, 'Nguy', 'Sửu Thìn Ngọ Mùi Tuất Hợi', 'Đông Bắc', 'Nam'),
      (
        28,
        'Canh Ngọ',
        8,
        'Thành',
        'Tý Sửu Mão Ngọ Thân Dậu',
        'Tây Bắc',
        'Tây Nam',
      ),
      (
        29,
        'Tân Mùi',
        9,
        'Thu',
        'Dần Mão Tỵ Thân Tuất Hợi',
        'Tây Nam',
        'Tây Nam',
      ),
      (30, 'Nhâm Thân', 10, 'Khai', 'Tý Sửu Thìn Tỵ Mùi Tuất', 'Nam', 'Tây'),
      (
        31,
        'Quý Dậu',
        11,
        'Bế',
        'Tý Dần Mão Ngọ Mùi Dậu',
        'Đông Nam',
        'Tây Bắc',
      ),
    ];
    for (final (d, canChi, lunarDay, truc, hours, hy, tai) in days) {
      test('$d/10/2025 $canChi', () {
        final a = almanacFor(DateTime(2025, 10, d));
        expect(
          a.lunar,
          LunarDate(day: lunarDay, month: 9, year: 2025, isLeapMonth: false),
        );
        expect(a.dayCanChi.name, canChi);
        expect(a.trucName, truc);
        expect(a.hoangDaoHours.map((h) => h.name).join(' '), hours);
        expect(a.hyThan, hy);
        expect(a.taiThan, tai);
        expect(a.monthCanChi.name, 'Bính Tuất');
        expect(a.yearCanChi.name, 'Ất Tỵ');
      });
    }

    test('22/10 is a Thiên Lao (hắc đạo) day in Hàn lộ', () {
      final a = almanacFor(DateTime(2025, 10, 22));
      expect(a.godName, 'Thiên Lao');
      expect(a.isHoangDao, isFalse);
      expect(a.solarTerm, 'Hàn lộ');
    });
  });

  group('xuất hành', () {
    // 6 Aug 2026 (24/6, Nhâm Tý): Không Vong, hỷ thần Nam, tài thần Tây
    // (baohatinh.vn); 6 Dec 2025 (17/10): Tốc Hỷ (baolamdong.vn).
    test('Khổng Minh lục diệu of reference days', () {
      final a = almanacFor(DateTime(2026, 8, 6));
      expect(
        a.lunar,
        const LunarDate(day: 24, month: 6, year: 2026, isLeapMonth: false),
      );
      expect(a.lucDieuDayInfo.name, 'Không Vong');
      expect(a.hyThan, 'Nam');
      expect(a.taiThan, 'Tây');
      final b = almanacFor(DateTime(2025, 12, 6));
      expect(
        b.lunar,
        const LunarDate(day: 17, month: 10, year: 2025, isLeapMonth: false),
      );
      expect(b.dayCanChi.name, 'Kỷ Dậu');
      expect(b.lucDieuDayInfo.name, 'Tốc Hỷ');
    });

    test(
      'Lý Thuần Phong hours are fixed: Tý/Ngọ Đại An … Tỵ/Hợi Không Vong',
      () {
        final a = almanacFor(DateTime(2025, 12, 6));
        expect(
          [for (final h in a.hours.take(6)) lucDieuInfoAt(h.lucDieu).name],
          [
            'Đại An',
            'Lưu Liên',
            'Tốc Hỷ',
            'Xích Khẩu',
            'Tiểu Cát',
            'Không Vong',
          ],
        );
        expect(a.hours[6].lucDieu, a.hours[0].lucDieu);
        expect(a.hours[11].lucDieu, a.hours[5].lucDieu);
      },
    );

    test('departure hours are hoàng đạo hours with a good lục diệu', () {
      for (final h in almanacFor(DateTime(2025, 10, 22)).departureHours) {
        expect(h.isHoangDao, isTrue);
        expect(lucDieuInfoAt(h.lucDieu).level, LucDieuLevel.good);
      }
    });
  });

  group('structure', () {
    test('every day has exactly six hoàng đạo hours and 12 hours', () {
      var d = DateTime(2026, 1, 1);
      for (var i = 0; i < 400; i++) {
        final a = almanacFor(d);
        expect(a.hours, hasLength(12));
        expect(a.hoangDaoHours, hasLength(6));
        d = d.add(const Duration(days: 1));
      }
    });

    test('lunar day advances by one and months have 29 or 30 days', () {
      var d = DateTime(2025, 1, 1);
      var prev = solarToLunar(d);
      for (var i = 0; i < 800; i++) {
        d = DateTime(d.year, d.month, d.day + 1);
        final cur = solarToLunar(d);
        if (cur.day == 1) {
          expect(prev.day, anyOf(29, 30), reason: 'before $d');
        } else {
          expect(cur.day, prev.day + 1, reason: '$d');
        }
        prev = cur;
      }
    });

    test('the jie day repeats the trực of the day before', () {
      // Lập xuân 2025 falls on 3 Feb (sun reaches 315° that day).
      final before = almanacFor(DateTime(2025, 2, 2)).truc;
      final jie = almanacFor(DateTime(2025, 2, 3)).truc;
      expect(jie, before);
    });
  });

  group('nhị thập bát tú', () {
    // 28 consecutive days from a printed almanac (quantrimang.com/lich-am):
    // 22/10/2025 Cơ … 18/11/2025 Vĩ.
    const sequence = [
      'Cơ', 'Đẩu', 'Ngưu', 'Nữ', 'Hư', 'Nguy', 'Thất', 'Bích', 'Khuê', //
      'Lâu', 'Vị', 'Mão', 'Tất', 'Chủy', 'Sâm', 'Tỉnh', 'Quỷ', 'Liễu', //
      'Tinh', 'Trương', 'Dực', 'Chẩn', 'Giác', 'Cang', 'Đê', 'Phòng', //
      'Tâm', 'Vĩ',
    ];

    test('28 reference days match the printed almanac', () {
      for (var i = 0; i < 28; i++) {
        final a = almanacFor(DateTime(2025, 10, 22 + i));
        expect(a.mansionDetail.name, sequence[i], reason: '${a.date}');
      }
    });

    test('far dates stay on the same cycle', () {
      expect(almanacFor(DateTime(2026, 8, 6)).mansionDetail.name, 'Khuê');
      expect(almanacFor(DateTime(2000, 1, 1)).mansionDetail.name, 'Vị');
    });

    test('the element follows the weekday (Mộc Thu … Thủy Wed)', () {
      const byWeekday = {
        DateTime.thursday: ['Mộc'],
        DateTime.friday: ['Kim'],
        DateTime.saturday: ['Thổ'],
        DateTime.sunday: ['Thái dương'],
        DateTime.monday: ['Thái âm'],
        DateTime.tuesday: ['Hỏa'],
        DateTime.wednesday: ['Thủy'],
      };
      var d = DateTime(1999, 1, 1);
      for (var i = 0; i < 3000; i++) {
        final a = almanacFor(d);
        expect(
          byWeekday[d.weekday],
          contains(a.mansionDetail.element),
          reason: '$d',
        );
        d = DateTime(d.year, d.month, d.day + 1);
      }
    });

    test('28 distinct mansions: 11 kiết, 5 bình, 12 hung', () {
      expect(lunarMansions, hasLength(28));
      expect({for (final m in lunarMansions) m.name}, hasLength(28));
      int count(MansionLevel l) =>
          lunarMansions.where((m) => m.level == l).length;
      expect(count(MansionLevel.kiet), 11);
      expect(count(MansionLevel.binh), 5);
      expect(count(MansionLevel.hung), 12);
    });
  });
}
