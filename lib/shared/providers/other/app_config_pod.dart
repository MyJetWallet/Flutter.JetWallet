import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../services/remote_config_service/service/remote_config_service.dart';

final appConfigPod = Provider<dynamic>((ref) {
  return RemoteConfigService().appConfig;
});
