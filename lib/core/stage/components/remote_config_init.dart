import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/screens/splash/splash_screen.dart';
import '../../../router/notifier/remote_config_notifier/remote_config_notipod.dart';

import '../../../shared/notifiers/time_tracking_notifier/time_tracking_notipod.dart';

/// Fetches and activates remote config, needed to go first after [AppRouter]
class RemoteConfigInit extends HookWidget {
  const RemoteConfigInit({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final remoteConfig = useProvider(remoteConfigNotipod);
    final timeTrackerN = useProvider(timeTrackingNotipod.notifier);

    return remoteConfig.when(
      success: () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await timeTrackerN.updateConfigReceived(DateTime.now());
        });
        return child;
      },
      loading: () => const SplashScreen(),
    );
  }
}
