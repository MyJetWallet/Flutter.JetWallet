import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

/// Needs to be ignored in the ProviderLogger to avoid an infinite loop
final logRecordsNotipod =
    StateNotifierProvider<LogRecordsNotifier, Queue<LogRecord>>(
  (ref) {
    return LogRecordsNotifier();
  },
  name: 'logRecordsNotipod',
);

class LogRecordsNotifier extends StateNotifier<Queue<LogRecord>> {
  LogRecordsNotifier() : super(Queue<LogRecord>()) {
    _logger = Logger.root.onRecord.listen((record) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        state.addLast(record);
        state = Queue.from(state);

        if (state.length > 100) {
          state.removeFirst();
          state = Queue.from(state);
        }
      });
    });
  }

  late final StreamSubscription<LogRecord> _logger;

  @override
  void dispose() {
    _logger.cancel();
    super.dispose();
  }
}
