import 'package:logging/logging.dart';

import '../../core/services/logs/helpers/make_log_pretty.dart';

String beatifyLogsForSupport(Iterable<LogRecord> logs) {
  final buffer = StringBuffer();

  for (final log in logs) {
    buffer.write(makeLogPretty(log, '<br>'));
    buffer.write('<br>');
  }

  return buffer.toString();
}

String beatifyLogsForShare(Iterable<LogRecord> logs) {
  final buffer = StringBuffer();

  for (final log in logs) {
    buffer.write(makeLogPretty(log, '\n'));
    buffer.write('\n');
  }

  return buffer.toString();
}
