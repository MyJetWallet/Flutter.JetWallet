import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class LogRecordsService {
  LogRecordsService() {
    _logger = Logger.root.onRecord.listen((record) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        logHistory.addLast(record);
        logHistory = Queue.from(logHistory);

        if (logHistory.length > 100) {
          logHistory.removeFirst();
          logHistory = Queue.from(logHistory);
        }
      });
    });
  }

  Queue<LogRecord> logHistory = Queue.from([]);

  late final StreamSubscription<LogRecord> _logger;
}
