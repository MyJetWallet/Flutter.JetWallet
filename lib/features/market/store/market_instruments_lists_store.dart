import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'market_instruments_lists_store.g.dart';

class MarketInstrumentsListsStore extends _MarketInstrumentsListsStoreBase with _$MarketInstrumentsListsStore {
  MarketInstrumentsListsStore() : super();

  static _MarketInstrumentsListsStoreBase of(BuildContext context) =>
      Provider.of<MarketInstrumentsListsStore>(context, listen: false);
}

abstract class _MarketInstrumentsListsStoreBase with Store {
  _MarketInstrumentsListsStoreBase() {
    activeMarketTab = watchListIds.isNotEmpty ? MarketTab.favorites : MarketTab.all;
    searchContriller.addListener(() {
      _searchText = searchContriller.text;
    });

    getIt<EventBus>().on<ShowMarketGainers>().listen((event) {
      setActiveMarketTab(MarketTab.gainers);
    });

    getIt<EventBus>().on<UnfocusTextField>().listen((event) {
      searchFocusNode.unfocus();
    });
  }
  final searchContriller = TextEditingController();

  final searchFocusNode = FocusNode();

  @observable
  String _searchText = '';

  @observable
  MarketTab activeMarketTab = MarketTab.favorites;

  @computed
  List<String> get watchListIds => sSignalRModules.keyValue.watchlist?.value ?? [];

  @computed
  ObservableList<MarketItemModel> get allList {
    final assets = [...sSignalRModules.marketItems];

    assets.sort(
      (a, b) => a.weight.compareTo(
        b.weight,
      ),
    );
    return ObservableList<MarketItemModel>.of(assets);
  }

  @computed
  ObservableList<MarketItemModel> get allListFiltred {
    final afterSearch = allList.where((marketItem) {
      final currency = getIt.get<FormatService>().findCurrency(
            findInHideTerminalList: true,
            assetSymbol: marketItem.symbol,
          );
      return currency.description.toLowerCase().contains(_searchText.toLowerCase()) ||
          currency.symbol.toLowerCase().contains(_searchText.toLowerCase());
    });
    return ObservableList<MarketItemModel>.of(afterSearch);
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
  ObservableList<MarketItemModel> get gainersListFiltred {
    final afterSearch = gainersList.where((marketItem) {
      final currency = getIt.get<FormatService>().findCurrency(
            findInHideTerminalList: true,
            assetSymbol: marketItem.symbol,
          );
      return currency.description.toLowerCase().contains(_searchText.toLowerCase()) ||
          currency.symbol.toLowerCase().contains(_searchText.toLowerCase());
    });
    return ObservableList<MarketItemModel>.of(afterSearch);
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
  ObservableList<MarketItemModel> get loosersListFiltred {
    final afterSearch = loosersList.where((marketItem) {
      final currency = getIt.get<FormatService>().findCurrency(
            findInHideTerminalList: true,
            assetSymbol: marketItem.symbol,
          );
      return currency.description.toLowerCase().contains(_searchText.toLowerCase()) ||
          currency.symbol.toLowerCase().contains(_searchText.toLowerCase());
    });
    return ObservableList<MarketItemModel>.of(afterSearch);
  }

  @computed
  ObservableList<MarketItemModel> get activeAssetsList {
    switch (activeMarketTab) {
      case MarketTab.all:
        return allListFiltred;
      case MarketTab.gainers:
        return gainersListFiltred;
      case MarketTab.lossers:
        return loosersListFiltred;
      default:
        return ObservableList<MarketItemModel>.of([]);
    }
  }

  @action
  void setActiveMarketTab(MarketTab marketTab) {
    clearSearch();
    activeMarketTab = marketTab;
  }

  @action
  void clearSearch() {
    searchFocusNode.unfocus();
    searchContriller.clear();
    _searchText = '';
  }

  @action
  void dispose() {
    searchContriller.dispose();
  }
}

enum MarketTab { favorites, all, gainers, lossers }
