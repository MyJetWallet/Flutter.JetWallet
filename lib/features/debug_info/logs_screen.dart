import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../core/l10n/i10n.dart';
import '../../core/services/logger_service/logger_service.dart';
import '../../core/services/logs/helpers/beatify_logs_for_support.dart';
import '../../core/services/logs/helpers/make_log_pretty.dart';

@RoutePage(name: 'LogsRouter')
class LogsScreen extends StatelessObserverWidget {
  const LogsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final logs = getIt.get<SimpleLoggerService>().logBuffer.toList().reversed.toList();

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        title: 'Debug screen',
        onRightIconTap: () => Share.share(beatifyLogsForShare(logs)),
        rightIcon: Assets.svg.small.info.simpleSvg(),
      ),
      child: SPaddingH24(
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            //return Text(makeLogPretty(logs[index], '\n'));
            return Text(makeLogPretty(logs[index], '\n'));
          },
        ),
      ),
    );
  }
}
