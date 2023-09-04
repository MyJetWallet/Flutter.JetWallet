import 'package:logging/logging.dart';

import '../../core/services/logs/helpers/debug_logging.dart';
import '../../core/services/logs/helpers/provider_logger.dart';
import '../logging.dart';

String makeLogPretty(LogRecord r, String breaker) {
  if (isConventionLevel(r)) {
    return '[${r.level.name}][${r.loggerName}][${r.message}][${logTime(r)}]'
        '$breaker${r.error} ${'-' * 80}';
  } else if (r.level.value == notifier.value) {
    return '${r.level.name} [${r.loggerName}] method [${r.message}] '
        'called at [${logTime(r)}] $breaker${'-' * 80}';
  } else if (r.level.value == providerLevel.value) {
    // Error will always be of the type of ProviderLog
    final log = r.error! as ProviderLog;

    final action = log.action;
    final provider = log.provider;
    final value = log.value;

    final pline = '[Provider]: $provider';

    return '${'-' * 80}$breaker$action$breaker'
        "${value != null ? '$pline$breaker[Value]: $value' : pline}";
  } else {
    return '[${r.level.name}]${loggerName(r)}[${logTime(r)}]'
        '$breaker${mainLog(r, '-')}';
  }
}
