import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';

final initFinishedSpod = StreamProvider<bool>((ref) {
  final signalRService = ref.watch(signalRServicePod);

  return signalRService.isAppLoaded();
});
