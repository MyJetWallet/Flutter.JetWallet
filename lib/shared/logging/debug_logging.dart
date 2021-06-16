import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'levels.dart';

/// There are 3 types of log messages:
/// 1. Convention Log Message - includes [Transport] [Contract] [State] levels
/// 2. Notifier Log Message - includes [Notifier] level
/// 3. General Log Message - includes [Other] levels
void debugLogging(LogRecord r) {
  if (isConventionLevel(r)) {
    debugPrint('''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
[${r.level.name}][${r.loggerName}][${r.message}][${logTime(r)}]
${r.error}
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                    
''', wrapWidth: 1024);
  } else if (r.level.value == notifier.value) {
    debugPrint('''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
${r.level.name} [${r.loggerName}] method [${r.message}] called at [${logTime(r)}]
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬                    
''', wrapWidth: 1024);
  } else if (r.level.value == providerLevel.value) {
    debugPrint(r.message, wrapWidth: 1024);
  } else {
    debugPrint('''
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
[${r.level.name}]${loggerName(r)}[${logTime(r)}]
${mainLog(r, '▬')}              
''', wrapWidth: 1024);
  }
}

String logTime(LogRecord record) {
  return DateFormat('hh:mm:ss').format(record.time).toString();
}

bool isConventionLevel(LogRecord record) {
  return record.level.value == transport.value ||
      record.level.value == contract.value ||
      record.level.value == stateFlow.value;
}

String loggerName(LogRecord record) {
  if (record.loggerName.isEmpty) {
    return '';
  } else {
    return '[${record.loggerName}]';
  }
}

String mainLog(LogRecord record, String underscore) {
  if (record.message.isEmpty) {
    if (record.error == null) {
      return underscore * 80;
    } else {
      return '${record.error}\n${underscore * 80}';
    }
  } else {
    if (record.error == null) {
      return 'Message: ${record.message}\n${underscore * 80}';
    } else {
      return 'Message: ${record.message}\n${record.error}\n${underscore * 80}';
    }
  }
}
