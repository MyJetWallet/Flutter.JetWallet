import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/providers/background/log_records_notipod.dart';
import '../helper/beatify_logs_for_support.dart';
import '../helper/make_log_pretty.dart';

class LogsScreen extends HookWidget {
  const LogsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logs = useProvider(logRecordsNotipod).toList().reversed.toList();

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Debug screen',
          showInfoButton: true,
          onInfoButtonTap: () => Share.share(beatifyLogsForShare(logs)),
        ),
      ),
      child: SPaddingH24(
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            return Text(makeLogPretty(logs[index], '\n'));
          },
        ),
      ),
    );
  }
}
