import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/local_storage_service.dart';

final depositDisclaimerFpod = FutureProvider<DepositDisclaimer>((ref) async {
  final storageService = ref.watch(localStorageServicePod);

  final disclaimer = await storageService.getString(depositDisclaimer);

  if (disclaimer == null) {
    return DepositDisclaimer.notAccepted;
  } else {
    return DepositDisclaimer.accepted;
  }
});

enum DepositDisclaimer {
  accepted,
  notAccepted,
}
