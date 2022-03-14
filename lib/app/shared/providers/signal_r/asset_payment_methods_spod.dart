import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/payment_methods.dart';
import '../../../../shared/providers/service_providers.dart';

final assetPaymentMethodsSpod =
    StreamProvider.autoDispose<AssetPaymentMethods>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.paymentMethods();
});
