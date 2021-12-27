import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'remote_config_notifier.dart';
import 'remote_config_union.dart';

final remoteConfigNotipod =
    StateNotifierProvider<RemoteConfigNotifier, RemoteConfigUnion>(
  (ref) {
    return RemoteConfigNotifier();
  },
  name: 'remoteConfigNotipod',
);
