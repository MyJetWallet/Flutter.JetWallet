
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/providers/background/log_records_notipod.dart';
import '../helper/encode_query_parameters.dart';
import '../helper/make_log_pretty.dart';

class LogsScreen extends HookWidget {
  const LogsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notipod = useProvider(logRecordsNotipod);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          if (notipod.isNotEmpty)
            for (final log in notipod.toList().reversed)
              Text(makeLogPretty(log, '\n'))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final buffer = StringBuffer();

          for (final log in notipod.toList().reversed) {
            buffer.write(makeLogPretty(log, '<br>'));
            buffer.write('<br>');
          }

          final _emailLaunchUri = Uri(
            scheme: 'mailto',
            path: 'illia.s@smplt.net, vladimir.m@smplt.net',
            query: encodeQueryParameters({
              'subject': 'JetWallet Logs',
              'body': buffer.toString(),
            }),
          );

          launch(_emailLaunchUri.toString());
        },
        child: const Icon(
          Icons.send,
        ),
      ),
    );
  }
}
