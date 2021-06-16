import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../shared/background_jobs/jobs/log_records_job.dart';
import '../../../shared/logging/debug_logging.dart';
import '../../../shared/logging/levels.dart';

/// Temporary screen
class Logs extends HookWidget {
  const Logs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notipod = useProvider(logRecordsNotipod);

    return ListView(
      children: [
        if (notipod.isNotEmpty)
          for (final log in notipod.toList().reversed) Text(_makeLogPretty(log))
      ],
    );
  }
}

String _makeLogPretty(LogRecord r) {
  if (isConventionLevel(r)) {
    return '[${r.level.name}][${r.loggerName}][${r.message}][${logTime(r)}]'
        '\n${r.error} ${'-' * 80}';
  } else if (r.level.value == notifier.value) {
    return '${r.level.name} [${r.loggerName}] method [${r.message}] '
        'called at [${logTime(r)}] \n${'-' * 80}';
  } else if (r.level.value == providerLevel.value) {
    return '${r.message.replaceAll('▬', '')}${'-' * 80}';
  } else {
    return '[${r.level.name}]${loggerName(r)}[${logTime(r)}]'
        '\n${mainLog(r, '-')}';
  }
}
