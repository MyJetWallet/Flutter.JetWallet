import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'market_info_spod.dart';

final marketInfoPod = Provider.autoDispose<Decimal>((ref) {
  final info = ref.watch(marketInfoSpod);
  var value = Decimal.zero;

  info.whenData((data) {
    value = data.marketCapChange24H.round(scale: 2);
  });

  return value;
});
