import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/clock/clock_provider.dart';
import '../domain/health_csv.dart';
import 'health_providers.dart';

/// Hands a file to the system share sheet; the user picks where it goes
/// (Zalo, Gmail, Drive, Files…). The app itself never uploads (D18/D19).
abstract interface class FileSharer {
  Future<void> share(File file, {required String mimeType, String? subject});
}

final class SystemFileSharer implements FileSharer {
  const SystemFileSharer();

  @override
  Future<void> share(
    File file, {
    required String mimeType,
    String? subject,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        subject: subject,
      ),
    );
  }
}

final fileSharerProvider = Provider<FileSharer>(
  (ref) => const SystemFileSharer(),
);

/// Cache folder for exports; overridden in tests.
final exportDirectoryProvider = Provider<Future<Directory> Function()>(
  (ref) =>
      () async =>
          Directory(p.join((await getTemporaryDirectory()).path, 'exports')),
);

final healthExporterProvider = Provider<HealthExporter>(HealthExporter.new);

final class HealthExporter {
  HealthExporter(this._ref);

  final Ref _ref;

  /// `an-suc-khoe-20261020-0630.csv`
  String fileName(String extension) {
    final t = _ref.read(appClockProvider).now();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'an-suc-khoe-${t.year}${two(t.month)}${two(t.day)}'
        '-${two(t.hour)}${two(t.minute)}.$extension';
  }

  /// Every reading, oldest first. Returns the written file.
  Future<File> exportCsv(CsvLabels labels, {String? subject}) async {
    final readings = await _ref.read(healthRepositoryProvider).all();
    final file = await _write(
      fileName('csv'),
      (f) => f.writeAsString(buildHealthCsv(readings, labels), flush: true),
    );
    await _ref
        .read(fileSharerProvider)
        .share(file, mimeType: 'text/csv', subject: subject);
    return file;
  }

  Future<File> exportPng(Uint8List png, {String? subject}) async {
    final file = await _write(
      fileName('png'),
      (f) => f.writeAsBytes(png, flush: true),
    );
    await _ref
        .read(fileSharerProvider)
        .share(file, mimeType: 'image/png', subject: subject);
    return file;
  }

  /// Health data should not pile up in the cache: earlier exports are
  /// removed before a new one is written.
  Future<File> _write(String name, Future<File> Function(File) write) async {
    final dir = await _ref.read(exportDirectoryProvider)();
    if (dir.existsSync()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
    return write(File(p.join(dir.path, name)));
  }
}
