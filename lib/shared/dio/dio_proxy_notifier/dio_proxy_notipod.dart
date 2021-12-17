import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dio_proxy_notifier.dart';
import 'dio_proxy_state.dart';

final dioProxyNotipod = StateNotifierProvider<DioProxyNotifier, DioProxyState>(
  (ref) {
    return DioProxyNotifier();
  },
  name: 'dioProxyNotipod',
);
