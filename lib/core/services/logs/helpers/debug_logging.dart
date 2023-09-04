import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';

import 'provider_logger.dart';

/// There are 4 types of log messages:
/// 1. Convention Log Message - includes [Transport] [Contract] [State] levels
/// 2. Notifier Log Message - includes [Notifier] level
/// 3. Provider Log Message - includes [Provider] level
/// 4. General Log Message - includes [Other] levels
void debugLogging(LogRecord r) {
  if (isConventionLevel(r)) {
    debugPrint(
      '''
$_underline
[${r.level.name}][${r.loggerName}][${r.message}][${logTime(r)}]
${r.error}
$_underline                    
''',
      wrapWidth: 1024,
    );
  } else if (r.level.value == notifier.value) {
    debugPrint(
      '''
$_underline
${r.level.name} [${r.loggerName}] method [${r.message}] called at [${logTime(r)}]
$_underline                    
''',
      wrapWidth: 1024,
    );
  } else if (r.level.value == providerLevel.value) {
    // Error will always be of the type of ProviderLog
    final log = r.error! as ProviderLog;

    final action = log.action;
    final provider = log.provider;
    final value = log.value;

    debugPrint(
      '''
$_underline
$action
[Provider]: $provider
${value != null ? '[Value]: $value \n$_underline' : _underline}
''',
      wrapWidth: 1024,
    );
  } else {
    debugPrint(
      '''
$_underline
[${r.level.name}]${loggerName(r)}[${logTime(r)}]
${mainLog(r, '▬')}              
''',
      wrapWidth: 1024,
    );
  }
}

String _underline = '▬' * 80;

String logTime(LogRecord record) {
  return DateFormat('hh:mm:ss').format(record.time);
}

bool isConventionLevel(LogRecord record) {
  return record.level.value == transport.value ||
      record.level.value == contract.value ||
      record.level.value == stateFlow.value;
}

String loggerName(LogRecord record) {
  return record.loggerName.isEmpty ? '' : '[${record.loggerName}]';
}

String mainLog(LogRecord record, String underscore) {
  if (record.message.isEmpty) {
    // ignore: prefer-conditional-expressions
    if (record.error == null) {
      return underscore * 80;
    } else {
      return '${record.error}\n${underscore * 80}';
    }
  } else {
    // ignore: prefer-conditional-expressions
    if (record.error == null) {
      return 'Message: ${record.message}\n${underscore * 80}';
    } else {
      return 'Message: ${record.message}\n${record.error}\n${underscore * 80}';
    }
  }
}
