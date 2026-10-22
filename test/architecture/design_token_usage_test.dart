import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces PRINCIPLES.md P02: raw colors, spacing, radii and font sizes live
/// only in lib/app/theme/. Runs with the package root as working directory.
void main() {
  const allowedDirs = ['lib/app/theme/', 'lib/app/localization/generated/'];
  final forbidden = {
    'raw Color literal': RegExp(r'Color\(0x'),
    'Material Colors palette': RegExp(r'\bColors\.'),
    'numeric EdgeInsets': RegExp(r'EdgeInsets\.\w+\([^)]*\b\d'),
    'numeric radius': RegExp(r'Radius\.circular\(\s*\d'),
    'inline fontSize': RegExp(r'fontSize:'),
  };

  test('widgets do not hardcode design values (P02)', () {
    final violations = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where(
          (f) => !allowedDirs.any(f.path.replaceAll(r'\', '/').startsWith),
        );

    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        for (final rule in forbidden.entries) {
          if (rule.value.hasMatch(lines[i])) {
            violations.add(
              '${file.path}:${i + 1} ${rule.key}: ${lines[i].trim()}',
            );
          }
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
