import 'package:logging/logging.dart';

import 'debug_logging.dart';

String makeLogPretty(LogRecord r, String breaker) {
  return '[${r.level.name}] [${r.loggerName}] [${logTime(r)}] \n${r.message}'
      '$breaker';
}
