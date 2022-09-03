import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../signal_r/asset_payment_methods_spod.dart';

final allPaymentsMethodsPod = Provider.autoDispose<List<String>>((ref) {
  final info = ref.watch(assetPaymentMethodsSpod);
  final showInfo = <String>[];

  info.whenData((value) {
    for (final asset in value.assets) {
      for (final method in asset.buyMethods) {
        showInfo.add(method.type.toString());
      }
    }
  });

  return showInfo;
});
