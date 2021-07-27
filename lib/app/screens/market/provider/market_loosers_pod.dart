import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/market_item_model.dart';
import 'market_items_pod.dart';

final marketLoosersPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final items = ref.watch(marketItemsPod);
  final loosers = items.where((item) => item.dayPercentChange < 0).toList();

  loosers.sort((a, b) => a.dayPercentChange.compareTo(b.dayPercentChange));

  return loosers;
});
