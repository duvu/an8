import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:an_nhien_eastern_content/an_nhien_eastern_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('all packs are draft; nothing appears as published', () async {
    final repo = EasternContentRepository();
    final index = await repo.getSystemIndex();
    expect((index['practiceSystems'] as List).length, 6);
    final bdj = await repo.getDraftCatalog('baduanjin');
    expect((bdj['exercises'] as List).length, 8);
    expect(EasternContentRepository.visiblePublishedRoutines(bdj), isEmpty);
  });
  test('xi sui jing contains no invented routine', () async {
    final repo = EasternContentRepository();
    final xi = await repo.getSystem('xisuijing');
    expect(xi['numberOfForms'], 0);
    expect(() => repo.getDraftCatalog('xisuijing'), throwsStateError);
  });
}
