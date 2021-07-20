import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/market_item_model.dart';
import 'market_items_pod.dart';

final marketGainersPod =
    Provider.autoDispose<List<MarketItemModel>>((ref) {
  final items = ref.watch(marketItemsPod);

  return items
      .where((item) => item.dayPercentChange > 0)
      .toList();
});
