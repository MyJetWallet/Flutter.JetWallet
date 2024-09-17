import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

extension MarketSectorModelExtension on MarketSectorModel {
  int get countOfTokens {
    return marketItems.length;
  }

  List<MarketItemModel> get marketItems {
    final marketItems = sSignalRModules.marketItems;
    final filtredMarketItems = marketItems.where((marketItem) => marketItem.sectorIds.contains(id)).toList();
    return filtredMarketItems;
  }

  List<MarketItemModel> get marketItemsSorterByWeight {
    final result = [...marketItems]..sort(
        (a, b) => a.weight.compareTo(
          b.weight,
        ),
      );
    return result;
  }
}
