import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/market/model/market_item_model.dart';
import 'package:jetwallet/service/services/signal_r/model/asset_model.dart';

import 'market_items_pod.dart';

final marketIndicesPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final items = ref.watch(marketItemsPod);
  final indices =
      items.where((item) => item.type == AssetType.indices).toList();

  return indices;
});
