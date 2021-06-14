import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'levels.dart';

/// There are 3 types of log messages:
/// 1. Convention Log Message - includes [Transport] [Contract] [State] levels
/// 2. Notifier Log Message - includes [Notifier] level
/// 3. General Log Message - includes [Other] levels
void debugLogging(LogRecord r) {
  if (_isConventionLevel(r)) {
    debugPrint(
      '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
[${r.level.name}][${r.loggerName}][${r.message}][$_timeNow]
${r.error}
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                    
''',
    );
  } else if (r.level.value == notifier.value) {
    debugPrint(
      '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
${r.level.name} [${r.loggerName}] method [${r.message}] called at [$_timeNow]
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                    
''',
    );
  } else {
    debugPrint(
      '''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
[${r.level.name}]${_loggerName(r)}[$_timeNow]
Message: ${r.message}
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                    
''',
    );
  }
}

String get _timeNow => DateFormat('hh:mm:ss').format(DateTime.now()).toString();

bool _isConventionLevel(LogRecord record) {
  return record.level.value == transport.value ||
      record.level.value == contract.value ||
      record.level.value == state.value;
}

String _loggerName(LogRecord record) {
  if (record.loggerName.isEmpty) {
    return '';
  } else {
    return '[${record.loggerName}]';
  }
}
