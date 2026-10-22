import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

/// L-009: frames that contradicted their own safety notes must never come back
/// (e.g. by re-running scripts/build_series_assets.py without fix_e04_e06.py).
const _rejected = {
  'E04 frame 03: arms raised overhead':
      '2ef95dae774e0587971c82c67b92301e11969b7928d953903e2b1fc9464c77ab',
  'E06 frame 02: knee lifted to hip height':
      '117ce6a4a189a09f3aa54cb38a62fe6770f729de5417d880f15b2e4ec66aca19',
  'E06 frame 03: knee lifted to hip height':
      '528ebaa5dbb98f1af8a45122ba2417890c1dae04e55b4b14496f0fd6de7ea901',
};

void main() {
  test('rejected E04/E06 frames are not shipped', () {
    final shipped = {
      for (final file
          in Directory('assets/series')
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.png')))
        sha256.convert(file.readAsBytesSync()).toString(): file.path,
    };
    for (final MapEntry(key: reason, value: hash) in _rejected.entries) {
      expect(shipped[hash], isNull, reason: reason);
    }
  });
}
