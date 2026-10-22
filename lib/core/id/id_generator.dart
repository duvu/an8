import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../clock/app_clock.dart';
import '../clock/clock_provider.dart';

/// Source of unique record ids.
abstract interface class IdGenerator {
  String next();
}

/// `<microseconds since epoch>-<random 32 bits>`; the random part keeps two
/// records created in the same microsecond apart.
final class TimeRandomIdGenerator implements IdGenerator {
  TimeRandomIdGenerator(this._clock, [Random? random])
    : _random = random ?? Random();

  final AppClock _clock;
  final Random _random;

  @override
  String next() =>
      '${_clock.now().microsecondsSinceEpoch}-${_random.nextInt(1 << 32)}';
}

final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => TimeRandomIdGenerator(ref.watch(appClockProvider)),
);
