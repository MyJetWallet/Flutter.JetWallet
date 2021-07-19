import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/market/provider/market_items_pod.dart';

import '../model/market_item_model.dart';

final gainersMarketItemsPod =
    Provider.autoDispose<List<MarketItemModel>>((ref) {
  final marketReferences = ref.watch(marketItemsPod);

  return marketReferences
      .where((marketReference) => marketReference.dayPercentChange > 0)
      .toList();
});
