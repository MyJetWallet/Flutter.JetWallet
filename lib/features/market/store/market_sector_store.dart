import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

part 'market_sector_store.g.dart';

class MarketSectorStore extends _MarketSectorStoreBase with _$MarketSectorStore {
  MarketSectorStore(super.sector, super.vsync) : super();

  static _MarketSectorStoreBase of(BuildContext context) => Provider.of<MarketSectorStore>(context, listen: false);
}

abstract class _MarketSectorStoreBase with Store {
  _MarketSectorStoreBase(this.sector, this.vsync) {
    tabController = TabController(length: 2, vsync: vsync);
    selectedFilter = marketItemsFilter.first;
    searchContriller.addListener(() {
      _searchText = searchContriller.text;
    });
    tabController.addListener(() {
      changeSorting(tabController.index);
    });
  }

  final MarketSectorModel sector;
  final TickerProvider vsync;

  final searchContriller = TextEditingController();
  late TabController tabController;

  @observable
  bool isShortDescription = true;

  @observable
  String _searchText = '';

  List<MarketItemsFilter> marketItemsFilter = [
    MarketItemsFilter(name: intl.market_market_cap, value: MarketItem.marketCap),
    MarketItemsFilter(name: intl.market_price_change, value: MarketItem.priceChange),
  ];

  @observable
  late MarketItemsFilter selectedFilter;

  @observable
  Sorting sorting = Sorting.desc;

  @computed
  ObservableList<MarketItemModel> get marketItems {
    final marketItems = sSignalRModules.marketItems;
    final filtredMarketItems = marketItems.where((marketItem) => marketItem.sectorIds.contains(sector.id));
    return ObservableList.of(filtredMarketItems);
  }

  @computed
  ObservableList<MarketItemModel> get filtredMarketItems {
    final result = <MarketItemModel>[];
    final afterSearch = marketItems.where((marketItem) {
      final currency = getIt.get<FormatService>().findCurrency(
            findInHideTerminalList: true,
            assetSymbol: marketItem.symbol,
          );
      return currency.description.toLowerCase().contains(_searchText.toLowerCase()) ||
          currency.symbol.toLowerCase().contains(_searchText.toLowerCase());
    });
    if (selectedFilter.value == MarketItem.priceChange) {
      if (sorting == Sorting.asc) {
        result.addAll(
          afterSearch.sorted((a, b) {
            return a.dayPercentChange.compareTo(b.dayPercentChange);
          }),
        );
      } else {
        result.addAll(
          afterSearch.sorted((a, b) {
            return b.dayPercentChange.compareTo(a.dayPercentChange);
          }),
        );
      }
    } else {
      if (sorting == Sorting.asc) {
        result.addAll(
          afterSearch.sorted((a, b) {
            return a.marketCap.compareTo(b.marketCap);
          }),
        );
      } else {
        result.addAll(
          afterSearch.sorted((a, b) {
            return b.marketCap.compareTo(a.marketCap);
          }),
        );
      }
    }
    return ObservableList.of(result);
  }

  @action
  void selectFilter(MarketItemsFilter newFilter) {
    selectedFilter = newFilter;
  }

  @action
  void changeSorting(int index) {
    if (index == 0) {
      sorting = Sorting.desc;
    } else {
      sorting = Sorting.asc;
    }
  }

  @action
  void setShortDescription() {
    isShortDescription = !isShortDescription;
  }

  @action
  void dispose() {
    searchContriller.dispose();
    tabController.dispose();
  }
}

class MarketItemsFilter {
  const MarketItemsFilter({required this.name, required this.value});

  final String name;
  final MarketItem value;

  @override
  String toString() {
    return name;
  }
}

enum MarketItem {
  marketCap,
  priceChange,
}

enum Sorting {
  asc,
  desc,
}
