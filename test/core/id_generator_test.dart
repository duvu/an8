import 'dart:math';

import 'package:an_nhien/core/id/id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

void main() {
  test('ids carry the clock time and differ for the same instant', () {
    final clock = FakeClock();
    final ids = TimeRandomIdGenerator(clock, Random(1));
    final a = ids.next();
    final b = ids.next();
    expect(a, isNot(b));
    expect(a.split('-').first, '${clock.now().microsecondsSinceEpoch}');
  });
}
