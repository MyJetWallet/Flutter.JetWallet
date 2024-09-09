import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'market_instruments_lists_store.g.dart';

class MarketInstrumentsListsStore extends _MarketInstrumentsListsStoreBase with _$MarketInstrumentsListsStore {
  MarketInstrumentsListsStore() : super();

  static _MarketInstrumentsListsStoreBase of(BuildContext context) => Provider.of<MarketInstrumentsListsStore>(context);
}

abstract class _MarketInstrumentsListsStoreBase with Store {
  @observable
  MarketTab activeMarketTab = MarketTab.favorites;

  @computed
  List<String> get watchListIds => sSignalRModules.keyValue.watchlist?.value ?? [];

  @computed
  ObservableList<MarketItemModel> get allList {
    final assets = sSignalRModules.marketItems;

    assets.sort(
      (a, b) => a.weight.compareTo(
        b.weight,
      ),
    );
    return assets;
  }

  @computed
  ObservableList<MarketItemModel> get favoritesList {
    final output = ObservableList<MarketItemModel>.of([]);

    for (var i = 0; i < watchListIds.length; i++) {
      final obj = allList.indexWhere((element) => element.symbol == watchListIds[i]);
      if (obj != -1) {
        output.add(allList[obj]);
      }
    }

    return output;
  }

  @computed
  ObservableList<MarketItemModel> get gainersList {
    final gainers = allList.where((item) => item.dayPercentChange >= 0).toList();
    gainers.sort(
      (a, b) => b.dayPercentChange.compareTo(
        a.dayPercentChange,
      ),
    );

    return ObservableList<MarketItemModel>.of(gainers);
  }

  @computed
  ObservableList<MarketItemModel> get loosersList {
    final losers = allList.where((item) => item.dayPercentChange < 0).toList();
    losers.sort(
      (a, b) => a.dayPercentChange.compareTo(
        b.dayPercentChange,
      ),
    );

    return ObservableList<MarketItemModel>.of(losers);
  }

  @computed
  ObservableList<MarketItemModel> get activeAssetsList {
    switch (activeMarketTab) {
      case MarketTab.all:
        return allList;
      case MarketTab.favorites:
        return favoritesList;
      case MarketTab.gainers:
        return gainersList;
      case MarketTab.lossers:
        return loosersList;
      default:
        return ObservableList<MarketItemModel>.of([]);
    }
  }

  @action
  void setActiveMarketTab(MarketTab marketTab) {
    activeMarketTab = marketTab;
  }
}

enum MarketTab { favorites, all, gainers, lossers }
