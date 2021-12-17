import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../logging/levels.dart';
import 'dio_proxy_state.dart';

class DioProxyNotifier extends StateNotifier<DioProxyState> {
  DioProxyNotifier() : super(const DioProxyState());

  static final _logger = Logger('DioProxyNotifier');

  void updateProxyName(String name) {
    _logger.log(notifier, 'updateProxyName');

    state = state.copyWith(proxyName: name);
  }
}
