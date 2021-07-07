import 'dart:convert';

import 'package:logging/logging.dart';

import '../../../shared/logging/debug_logging.dart';
import '../../../shared/logging/levels.dart';

String makeLogPretty(LogRecord r, String breaker) {
  if (isConventionLevel(r)) {
    return '[${r.level.name}][${r.loggerName}][${r.message}][${logTime(r)}]'
        '$breaker${r.error} ${'-' * 80}';
  } else if (r.level.value == notifier.value) {
    return '${r.level.name} [${r.loggerName}] method [${r.message}] '
        'called at [${logTime(r)}] $breaker${'-' * 80}';
  } else if (r.level.value == providerLevel.value) {
    final json = jsonDecode(r.message) as Map<String, dynamic>;

    final action = json['action'].toString();
    final provider = json['provider'].toString();
    final value = json['value'];

    final providerS = '[Provider]: $provider';

    return '${'-' * 80}$breaker$action$breaker'
        "${value != null ? '$providerS$breaker[Value]: $value' : providerS}";
  } else {
    return '[${r.level.name}]${loggerName(r)}[${logTime(r)}]'
        '$breaker${mainLog(r, '-')}';
  }
}
