import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

extension MarketSectorModelExtension on MarketSectorModel {
  int get countOfTokens {
    final marketItems = sSignalRModules.marketItems;
    final filtredMarketItems = marketItems.where((marketItem) => marketItem.sectorId == id);
    return filtredMarketItems.length;
  }
}
