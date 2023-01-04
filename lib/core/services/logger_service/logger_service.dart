import 'dart:collection';
import 'package:logger/logger.dart';

class SimpleLoggerService {
  SimpleLoggerService({Logger? logger}) {
    _simpleOutput = SimpleLoggerOutput();

    _logger = logger ??
        Logger(
          printer: PrettyPrinter(),
          output: _simpleOutput,
        );
  }

  late final Logger _logger;
  late final SimpleLoggerOutput _simpleOutput;

  Logger get logger => _logger;

  void log({
    required Level level,
    required String place,
    required String message,
  }) {
    logger.log(level, '$place - $message');
  }

  String logsForShare() {
    final buffer = StringBuffer();

    for (final log in _simpleOutput.buffer) {
      buffer.write(log);
      buffer.write('\n');
    }

    return buffer.toString();
  }

  void clear() {
    _simpleOutput.buffer.clear();
  }
}

class SimpleLoggerOutput implements MemoryOutput {
  SimpleLoggerOutput() {
    buffer = ListQueue(bufferSize);
  }

  @override
  late final ListQueue<OutputEvent> buffer;

  @override
  int get bufferSize => 60;

  @override
  void destroy() {}

  @override
  void init() {}

  @override
  void output(OutputEvent event) {
    if (buffer.length == bufferSize) {
      buffer.removeFirst();
    }

    buffer.add(event);

    secondOutput?.output(event);
  }

  @override
  LogOutput? get secondOutput => ConsoleOutput();
}
