import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Iterable<File> _dartFiles(bool Function(String path) include) =>
    Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => include(f.path.replaceAll(r'\', '/')));

List<String> _violations(Iterable<File> files, RegExp rule) => [
  for (final f in files)
    for (final (i, line) in f.readAsLinesSync().indexed)
      if (rule.hasMatch(line)) '${f.path}:${i + 1}: ${line.trim()}',
];

void main() {
  test('domain layers are pure Dart (P08)', () {
    final violations = _violations(
      _dartFiles((p) => p.contains('/domain/')),
      RegExp(r"^import 'package:(?!an_nhien/)"),
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('UI never hardcodes exercise/routine ids (P01)', () {
    final violations = _violations(
      _dartFiles(
        (p) => p.contains('/presentation/') || p.startsWith('lib/app/'),
      ),
      RegExp(r"""['"][ER]\d{2,}['"]"""),
    );
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
