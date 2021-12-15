import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../router/notifier/startup_notifier/startup_notipod.dart';
import '../services/deep_link_service.dart';

final
deepLinkServicePod = Provider<DeepLinkService>(
  (ref) {
    final navigatorKey = ref.watch(sNavigatorKeyPod);
    final startup = ref.watch(startupNotipod);

    return DeepLinkService(
      read: ref.read,
      navigatorKey: navigatorKey,
      startup: startup,
    );
  },
  name: 'deepLinkServicePod',
);
