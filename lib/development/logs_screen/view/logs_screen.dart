import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/background/log_records_notipod.dart';
import '../helper/beatify_logs_for_support.dart';
import '../helper/make_log_pretty.dart';
import '../helper/send_logs_to_support.dart';

class LogsScreen extends HookWidget {
  const LogsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logs = useProvider(logRecordsNotipod).toList().reversed;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          if (logs.isNotEmpty)
            for (final log in logs) Text(makeLogPretty(log, '\n'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendLogsToSupport(
            beatifyLogsForSupport(logs),
          );
        },
        child: const Icon(
          Icons.send,
        ),
      ),
    );
  }
}
