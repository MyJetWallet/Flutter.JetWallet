import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'market_info_spod.dart';

final marketInfoPod = Provider.autoDispose<Decimal>((ref) {
  final marketInfo = ref.watch(marketInfoSpod);
  var value = Decimal.zero;

  marketInfo.whenData((data) {
    value =
        data.marketInfo[0].totalMarketInfo.marketCapChange24H.round(scale: 2);
  });

  return value;
});
