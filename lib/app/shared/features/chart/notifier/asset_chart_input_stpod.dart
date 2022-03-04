import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/market/model/market_item_model.dart';
import '../model/chart_input.dart';

final assetChartInputStpod = StateProvider.autoDispose
    .family<ChartInput, MarketItemModel>((ref, marketItem) {
  return ChartInput(
    creationDate: marketItem.startMarketTime,
    instrumentId: marketItem.associateAssetPair,
  );
});
