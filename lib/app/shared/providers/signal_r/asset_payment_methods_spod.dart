import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/asset_payment_methods.dart';

import '../../../../shared/providers/service_providers.dart';

final assetPaymentMethodsSpod =
    StreamProvider.autoDispose<AssetPaymentMethods>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.paymentMethods();
});
