import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

final logRecordsPod = Provider<Queue<LogRecord>>((ref) {
  return Queue<LogRecord>();
}, name: 'logRecordsPod');

final logRecordsJob = Provider<void>((ref) {
  final logs = ref.watch(logRecordsPod);

  Logger.root.onRecord.listen((record) {
    logs.addLast(record);

    if (logs.length > 100) {
      logs.removeFirst();
    }
  });
}, name: 'logRecordsJob');
