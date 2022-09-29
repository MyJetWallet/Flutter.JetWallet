import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logs/helpers/make_log_pretty.dart';
import 'package:jetwallet/core/services/logs/log_record_service.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/splash_screen_gradient.dart';
import 'package:logging/logging.dart';
import 'package:rive/rive.dart';
import 'package:share_plus/share_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
      Image.asset(simpleAppImageAsset).image,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final logs =
        getIt.get<LogRecordsService>().logHistory.toList().reversed.toList();

    return Scaffold(
      body: InkWell(
        onTap: () {
          Share.share(beatifyLogsForShare(logs));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Share.share(beatifyLogsForShare(logs));
              },
              child: Container(
                width: 300,
                height: 300,
                child: Text(
                  'SHARE DEBUG INFO',
                ),
              ),
            ),
            const Center(
              child: SizedBox(
                width: 320.0,
                height: 320.0,
                child: RiveAnimation.asset(splashAnimationAsset),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String beatifyLogsForShare(Iterable<LogRecord> logs) {
  final buffer = StringBuffer();

  for (final log in logs) {
    buffer.write(makeLogPretty(log, '\n'));
    buffer.write('\n');
  }

  return buffer.toString();
}
