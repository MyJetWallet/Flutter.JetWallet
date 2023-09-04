import 'dart:collection';
import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as logging;

class SimpleLoggerService {
  SimpleLoggerService({Logger? logger}) {
    _logger = logger ??
        Logger(
          printer: PrettyPrinter(),
        );
  }

  late final Logger _logger;
  Logger get logger => _logger;

  int get bufferSize => 60;

  Queue<logging.LogRecord> logBuffer = Queue.from([]);

  void log({
    required Level level,
    required String place,
    required String message,
  }) {
    if (logBuffer.length == bufferSize) {
      logBuffer.removeFirst();
    }

    logBuffer.add(
      logging.LogRecord(
        convertLog(level),
        message,
        place,
      ),
    );

    final time = DateTime.now();

    logger.log(level, '$place (${time.minute}:${time.second}) - $message');
  }

  logging.Level convertLog(Level level) {
    switch (level) {
      case Level.info:
        return const logging.Level('ℹ️ Info', 1);
      case Level.debug:
        return const logging.Level('⚠️ Debug', 2);
      case Level.error:
        return const logging.Level('🆘 Error', 3);
      case Level.warning:
        return const logging.Level('⚠️ Warning', 4);
      default:
        return const logging.Level('ℹ️ Info', 1);
    }
  }

  void clear() {
    logBuffer.clear();
  }
}
