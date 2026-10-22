import 'package:an_nhien/features/calendar/domain/day_activities.dart';
import 'package:an_nhien/features/calendar/domain/day_almanac.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ActivityAdvice adviceOf(DayAlmanac a, Activity activity) =>
      adviceFor(a).firstWhere((x) => x.activity == activity);

  Verdict verdictOf(DayAlmanac a, Activity activity) =>
      adviceOf(a, activity).verdict;

  /// First day on or after [from] whose trực is [truc].
  DayAlmanac dayWithTruc(int truc, {DateTime? from}) {
    var d = from ?? DateTime(2025, 10, 1);
    while (true) {
      final a = almanacFor(d);
      if (a.truc == truc) return a;
      d = DateTime(d.year, d.month, d.day + 1);
    }
  }

  group(
    '22/10/2025: Giáp Tý, hắc đạo Thiên Lao, trực Mãn, sao Cơ, Tiểu Cát',
    () {
      final a = almanacFor(DateTime(2025, 10, 22));

      test('wedding is discouraged: only the hắc đạo speaks', () {
        final advice = adviceOf(a, Activity.wedding);
        expect(advice.verdict, Verdict.unfavorable);
        expect(advice.evidence, hasLength(1));
        expect(advice.evidence.single.source, EvidenceSource.hoangDao);
        expect(advice.evidence.single.name, 'Thiên Lao');
      });

      test('sao Cơ makes opening, building and burial even', () {
        for (final activity in [
          Activity.opening,
          Activity.building,
          Activity.burial,
        ]) {
          final advice = adviceOf(a, activity);
          expect(advice.verdict, Verdict.neutral, reason: '$activity');
          expect(
            advice.evidence
                .where((e) => e.source == EvidenceSource.mansion)
                .single
                .favorable,
            isTrue,
          );
        }
      });

      test('departure: sao Cơ and Tiểu Cát outweigh the hắc đạo', () {
        final advice = adviceOf(a, Activity.departure);
        expect(advice.verdict, Verdict.favorable);
        expect(advice.evidence.map((e) => e.source), [
          EvidenceSource.hoangDao,
          EvidenceSource.mansion,
          EvidenceSource.lucDieu,
        ]);
        expect(advice.evidence.map((e) => e.favorable), [false, true, true]);
      });

      test('lawsuit has no pointer today', () {
        final advice = adviceOf(a, Activity.lawsuit);
        expect(advice.verdict, Verdict.neutral);
        expect(advice.evidence, isEmpty);
      });
    },
  );

  group('trực', () {
    test('Kiến: departure and wedding for, building against', () {
      final a = dayWithTruc(0);
      expect(a.trucName, 'Kiến');
      bool trucFavors(Activity x) => adviceOf(
        a,
        x,
      ).evidence.singleWhere((e) => e.source == EvidenceSource.truc).favorable;
      expect(trucFavors(Activity.departure), isTrue);
      expect(trucFavors(Activity.wedding), isTrue);
      expect(trucFavors(Activity.building), isFalse);
    });

    test('Trừ speaks against wedding, opening and building', () {
      final a = dayWithTruc(1);
      for (final x in [Activity.wedding, Activity.opening, Activity.building]) {
        final e = adviceOf(
          a,
          x,
        ).evidence.singleWhere((e) => e.source == EvidenceSource.truc);
        expect(e.favorable, isFalse, reason: '$x');
      }
    });

    test('Định discourages lawsuits', () {
      final a = dayWithTruc(4);
      expect(verdictOf(a, Activity.lawsuit), Verdict.unfavorable);
    });

    test('a bad trực is against every major activity', () {
      for (final truc in [6, 7, 11]) {
        final a = dayWithTruc(truc);
        for (final x in Activity.values.where((x) => x != Activity.lawsuit)) {
          final e = adviceOf(
            a,
            x,
          ).evidence.where((e) => e.source == EvidenceSource.truc);
          expect(e.single.favorable, isFalse, reason: '${a.trucName} $x');
        }
      }
    });

    test('Thành and Khai speak for wedding, opening and building', () {
      for (final truc in [8, 10]) {
        final a = dayWithTruc(truc);
        for (final x in [
          Activity.wedding,
          Activity.opening,
          Activity.building,
        ]) {
          final e = adviceOf(
            a,
            x,
          ).evidence.singleWhere((e) => e.source == EvidenceSource.truc);
          expect(e.favorable, isTrue, reason: '${a.trucName} $x');
        }
      }
    });
  });

  group('sao', () {
    DayAlmanac dayWithMansion(String name) {
      var d = DateTime(2025, 10, 1);
      while (almanacFor(d).mansionDetail.name != name) {
        d = DateTime(d.year, d.month, d.day + 1);
      }
      return almanacFor(d);
    }

    test(
      'Phòng is for wedding, building, burial and departure, never against',
      () {
        final a = dayWithMansion('Phòng');
        for (final x in [
          Activity.wedding,
          Activity.building,
          Activity.burial,
          Activity.departure,
        ]) {
          final e = adviceOf(
            a,
            x,
          ).evidence.singleWhere((e) => e.source == EvidenceSource.mansion);
          expect(e.favorable, isTrue, reason: '$x');
        }
      },
    );

    test('Chủy is against building and burial', () {
      final a = dayWithMansion('Chủy');
      for (final x in [Activity.building, Activity.burial]) {
        final e = adviceOf(
          a,
          x,
        ).evidence.singleWhere((e) => e.source == EvidenceSource.mansion);
        expect(e.favorable, isFalse, reason: '$x');
      }
    });

    test('Khuê and Cang discourage lawsuits', () {
      expect(
        verdictOf(dayWithMansion('Khuê'), Activity.lawsuit),
        Verdict.unfavorable,
      );
      expect(
        verdictOf(dayWithMansion('Cang'), Activity.lawsuit),
        Verdict.unfavorable,
      );
    });

    test('Mão is against departure; Quỷ for burial but against wedding', () {
      final mao = adviceOf(dayWithMansion('Mão'), Activity.departure);
      expect(
        mao.evidence
            .singleWhere((e) => e.source == EvidenceSource.mansion)
            .favorable,
        isFalse,
      );
      final quy = dayWithMansion('Quỷ');
      expect(
        adviceOf(quy, Activity.burial).evidence
            .singleWhere((e) => e.source == EvidenceSource.mansion)
            .favorable,
        isTrue,
      );
      expect(
        adviceOf(quy, Activity.wedding).evidence
            .singleWhere((e) => e.source == EvidenceSource.mansion)
            .favorable,
        isFalse,
      );
    });
  });

  group('structure', () {
    test('every day gives six answers; lawsuits are never "nên làm"', () {
      var d = DateTime(2026, 1, 1);
      for (var i = 0; i < 400; i++) {
        final a = almanacFor(d);
        final all = adviceFor(a);
        expect(all.map((x) => x.activity), Activity.values);
        expect(verdictOf(a, Activity.lawsuit), isNot(Verdict.favorable));
        for (final x in all) {
          final score = x.evidence.fold<int>(
            0,
            (s, e) => s + (e.favorable ? 1 : -1),
          );
          expect(
            x.verdict,
            score > 0 && x.activity != Activity.lawsuit
                ? Verdict.favorable
                : score < 0
                ? Verdict.unfavorable
                : Verdict.neutral,
            reason: '$d ${x.activity}',
          );
        }
        d = DateTime(d.year, d.month, d.day + 1);
      }
    });

    test('hoàng đạo is for, hắc đạo against, except for lawsuits', () {
      for (final hoang in [true, false]) {
        var d = DateTime(2025, 10, 1);
        while (almanacFor(d).isHoangDao != hoang) {
          d = DateTime(d.year, d.month, d.day + 1);
        }
        final a = almanacFor(d);
        for (final x in Activity.values) {
          final e = adviceOf(
            a,
            x,
          ).evidence.where((e) => e.source == EvidenceSource.hoangDao);
          if (x == Activity.lawsuit) {
            expect(e, isEmpty);
          } else {
            expect(e.single.favorable, hoang);
          }
        }
      }
    });
  });
}
