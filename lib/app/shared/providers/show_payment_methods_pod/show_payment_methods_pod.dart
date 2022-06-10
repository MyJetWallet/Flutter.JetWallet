import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../signal_r/asset_payment_methods_spod.dart';

final showPaymentsMethodsPod = Provider.autoDispose<bool>((ref) {
  final info = ref.watch(assetPaymentMethodsSpod);
  var showInfo = false;

  info.whenData((value) {
    showInfo = value.showCardsInProfile;
  });

  return showInfo;
});
