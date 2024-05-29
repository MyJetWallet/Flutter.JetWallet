import 'dart:convert';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/modules/signal_r/models/invest_base_daily_price_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_prices_model.dart';
import 'package:simple_networking/modules/signal_r/models/invest_sectors_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/key_value_service.dart';
import '../../../../utils/enum.dart';
import '../../../../utils/helpers/currency_from.dart';

part 'invest_dashboard_store.g.dart';

@lazySingleton
class InvestDashboardStore = _InvestDashboardStoreBase with _$InvestDashboardStore;

abstract class _InvestDashboardStoreBase with Store {
  _InvestDashboardStoreBase() {
    loader = StackLoaderStore();
  }

  @observable
  StackLoaderStore? loader;

  @computed
  InvestInstrumentsModel? get investInstrumentsData => sSignalRModules.investInstrumentsData;
  @computed
  InvestSectorsModel? get investSectorsData => sSignalRModules.investSectorsData;
  @computed
  InvestPositionsModel? get investPositionsData => sSignalRModules.investPositionsData;
  @computed
  InvestPricesModel? get investPricesData => sSignalRModules.investPricesData;
  @computed
  InvestBaseDailyPriceModel? get investBaseDailyPriceData => sSignalRModules.investBaseDailyPriceData;

  @computed
  List<InvestInstrumentModel> get instrumentsList => investInstrumentsData?.instruments ?? [];

  @computed
  ObservableList<InvestInstrumentModel> get myInvestsList {
    final positions = positionsList;
    final activePositions = positions.where((position) => position.status == PositionStatus.opened);
    final myInvestsList = instrumentsList
        .where(
          (instrument) => activePositions.any(
            (position) => position.symbol == instrument.symbol,
          ),
        )
        .toList();
    myInvestsList.sort((first, second) {
      final firstAmount = _getGroupedProfit(first.symbol ?? '');
      final secondAmount = _getGroupedProfit(second.symbol ?? '');

      return secondAmount.compareTo(firstAmount);
    });
    return ObservableList.of(myInvestsList);
  }

  @computed
  ObservableList<InvestInstrumentModel> get myInvestPendingList {
    final positions = positionsList;
    final activePositions = positions.where((position) => position.status == PositionStatus.pending);
    final myInvestsList = instrumentsList
        .where(
          (instrument) => activePositions.any(
            (position) => position.symbol == instrument.symbol,
          ),
        )
        .toList();
    myInvestsList.sort((first, second) {
      final firstAmount = _getGroupedProfit(first.symbol ?? '');
      final secondAmount = _getGroupedProfit(second.symbol ?? '');

      return secondAmount.compareTo(firstAmount);
    });
    return ObservableList.of(myInvestsList);
  }

  Decimal _getGroupedProfit(String symbol) {
    final investPositionsStore = getIt.get<InvestPositionsStore>();

    final groupedPositions = investPositionsStore.activeList
        .where(
          (element) => element.symbol == symbol,
        )
        .toList();
    var profit = Decimal.zero;
    for (var i = 0; i < groupedPositions.length; i++) {
      profit += getProfitByPosition(groupedPositions[i]);
    }

    return profit;
  }

  @observable
  TextEditingController searchController = TextEditingController();

  @observable
  String instrumentSearch = '';

  @observable
  int instrumentSort = 0;

  @observable
  int favoritesSort = 0;

  @observable
  bool isShortDescription = true;

  @observable
  bool _isFavoritesEditMode = false;

  @computed
  bool get isFavoritesEditMode => _isFavoritesEditMode;

  @observable
  String activeSection = '';
  @computed
  ObservableList<InvestSectorModel> get sections {
    final listForSort = investSectorsData?.sectors ?? [];
    listForSort.sort(
      (a, b) => (a.id ?? '').compareTo(b.id ?? ''),
    );

    final all = listForSort.firstWhere((sector) => sector.id == 'all');
    listForSort.removeWhere((sector) => sector.id == 'all');
    listForSort.insert(0, all);

    return ObservableList.of(
      listForSort,
    );
  }

  @observable
  InvestHistoryPeriod period = InvestHistoryPeriod.week;

  @action
  void updatePeriod(InvestHistoryPeriod newValue) {
    period = newValue;
  }

  @computed
  ObservableList<String> get favoritesSymbols => ObservableList.of(
        sSignalRModules.keyValue.favoritesInstruments?.value ?? ['BTC', 'ETH'],
      );

  @computed
  ObservableList<InvestInstrumentModel> get instrumentsSortedList {
    final activeList = instrumentsList;
    final sortedList = <InvestInstrumentModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (activeList[i].description!.toLowerCase().contains(instrumentSearch.toLowerCase()) ||
            activeList[i].name!.toLowerCase().contains(instrumentSearch.toLowerCase())) {
          if (activeList[i].sectors != null &&
              activeList[i]
                  .sectors!
                  .where(
                    (element) => element == activeSection,
                  )
                  .toList()
                  .isNotEmpty) {
            sortedList.add(activeList[i]);
          }
        }
      }

      Decimal getGroupedProfit(String symbol) {
        final groupedPositions = positionsList
            .where(
              (element) => element.symbol == symbol && element.status == PositionStatus.opened,
            )
            .toList();
        var profit = Decimal.zero;
        for (var i = 0; i < groupedPositions.length; i++) {
          profit += getProfitByPosition(groupedPositions[i]);
        }

        return profit;
      }

      int getGroupedLength(String symbol) {
        final groupedPositions = positionsList.where(
          (element) => element.symbol == symbol,
        );

        return groupedPositions.length;
      }

      if (instrumentSort == 1) {
        sortedList.sort(
          (a, b) => getGroupedProfit(b.symbol!).compareTo(
            getGroupedProfit(a.symbol!),
          ),
        );
      } else if (instrumentSort == 2) {
        sortedList.sort(
          (a, b) => getGroupedProfit(a.symbol!).compareTo(
            getGroupedProfit(b.symbol!),
          ),
        );
      } else {
        sortedList.sort(
          (a, b) => getGroupedLength(b.symbol!).compareTo(
            getGroupedLength(a.symbol!),
          ),
        );
      }
    }

    return ObservableList.of(sortedList);
  }

  @computed
  ObservableList<InvestInstrumentModel> get favoritesSortedList {
    final activeList = favouritesList;
    final sortedList = <InvestInstrumentModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (activeList[i].description!.toLowerCase().contains(instrumentSearch.toLowerCase()) ||
            activeList[i].name!.toLowerCase().contains(instrumentSearch.toLowerCase())) {
          sortedList.add(activeList[i]);
        }
      }

      if (favoritesSort == 1) {
        sortedList.sort(
          (a, b) => getPriceBySymbol(b.symbol!).compareTo(
            getPriceBySymbol(a.symbol!),
          ),
        );
      } else if (favoritesSort == 2) {
        sortedList.sort(
          (a, b) => getPriceBySymbol(a.symbol!).compareTo(
            getPriceBySymbol(b.symbol!),
          ),
        );
      }
    }

    return ObservableList.of(sortedList);
  }

  @computed
  ObservableList<InvestInstrumentModel> get losersList {
    final instruments = investInstrumentsData?.instruments ?? [];
    final losers = instruments
        .where(
          (instrument) => getPercentSymbol(instrument.symbol ?? '') < Decimal.zero,
        )
        .toList();

    losers.sort(
      (a, b) => getPercentSymbol(b.symbol ?? '').compareTo(
        getPercentSymbol(a.symbol ?? ''),
      ),
    );

    return ObservableList.of(losers.sublist(0, min(losers.length, 5)));
  }

  @computed
  ObservableList<InvestInstrumentModel> get gainersList {
    final activeList = instrumentsList;
    final gainers = <InvestInstrumentModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        if (getPercentSymbol(activeList[i].symbol ?? '') > Decimal.zero) {
          gainers.add(activeList[i]);
        }
      }
      gainers.sort(
        (a, b) => getPercentSymbol(b.symbol ?? '').compareTo(
          getPercentSymbol(a.symbol ?? ''),
        ),
      );
    }

    return ObservableList.of(gainers.sublist(0, min(gainers.length, 5)));
  }

  @computed
  ObservableList<InvestInstrumentModel> get favouritesList {
    final activeList = instrumentsList;
    final favorites = <InvestInstrumentModel>[];
    if (activeList.isNotEmpty) {
      for (var i = 0; i < activeList.length; i++) {
        final currency = currencyFrom(
          sSignalRModules.currenciesList,
          activeList[i].currencyBase!,
        );
        if (favoritesSymbols.contains(currency.symbol)) {
          favorites.add(activeList[i]);
        }
      }
    }

    return ObservableList.of(favorites);
  }

  @computed
  List<InvestPositionModel> get positionsList => investPositionsData?.positions ?? [];

  @computed
  List<InvestPriceModel> get pricesList => investPricesData?.prices ?? [];

  @computed
  List<BaseDailyPrice> get basePricesList => investBaseDailyPriceData?.dailyPrices ?? [];

  @computed
  Decimal get totalAmount {
    var amountSum = Decimal.zero;
    if (investPositionsData != null) {
      final activePositions = positionsList
          .where(
            (element) => element.status == PositionStatus.opened,
          )
          .toList();
      for (var i = 0; i < activePositions.length; i++) {
        amountSum += activePositions[i].amount!;
      }
    }

    return amountSum;
  }

  @computed
  Decimal get totalPendingAmount {
    var amountSum = Decimal.zero;
    if (investPositionsData != null) {
      final activePositions = positionsList
          .where(
            (element) => element.status == PositionStatus.pending,
          )
          .toList();
      for (var i = 0; i < activePositions.length; i++) {
        amountSum += activePositions[i].amount!;
      }
    }

    return amountSum;
  }

  @computed
  Decimal get totalProfit {
    var profitSum = Decimal.zero;
    if (investPositionsData != null) {
      final activePositions = positionsList
          .where(
            (element) => element.status == PositionStatus.opened,
          )
          .toList();
      for (var i = 0; i < activePositions.length; i++) {
        profitSum += getProfitByPosition(activePositions[i]);
      }
    }

    return profitSum;
  }

  @computed
  InvestSectorModel get sectionById {
    return sections.firstWhere((element) => element.id == activeSection);
  }

  @computed
  Decimal get totalYield {
    var amountSum = Decimal.zero;
    var profitSum = Decimal.zero;
    if (investPositionsData != null) {
      final activePositions = positionsList
          .where(
            (element) => element.status == PositionStatus.opened,
          )
          .toList();
      for (var i = 0; i < activePositions.length; i++) {
        amountSum += activePositions[i].amount!;
        profitSum += getProfitByPosition(activePositions[i]);
      }
    }

    if (profitSum == Decimal.zero || amountSum == Decimal.zero) {
      return Decimal.zero;
    }

    return Decimal.fromJson('${(Decimal.fromInt(100) * profitSum / amountSum).toDouble()}');
  }

  @action
  String getPriceBySymbol(String symbol) {
    final instrument = instrumentsList.where((element) => element.symbol == symbol).toList();
    final price = pricesList.where((element) => element.symbol == symbol).toList();
    if (instrument.isEmpty || price.isEmpty) {
      return '-';
    }

    return marketFormat(
      decimal: price[0].lastPrice!,
      symbol: '',
      accuracy: instrument[0].priceAccuracy!,
    );
  }

  @action
  Decimal getPendingPriceBySymbol(String symbol) {
    final instrument = instrumentsList.where((element) => element.symbol == symbol).toList();
    final price = pricesList.where((element) => element.symbol == symbol).toList();
    if (instrument.isEmpty || price.isEmpty) {
      return Decimal.zero;
    }

    return price[0].lastPrice ?? Decimal.zero;
  }

  @action
  Decimal getBasePriceBySymbol(String symbol) {
    final instrument = instrumentsList.where((element) => element.symbol == symbol).toList();
    final price = basePricesList.where((element) => element.symbol == symbol).toList();
    if (instrument.isEmpty || price.isEmpty) {
      return Decimal.zero;
    }

    return price[0].price ?? Decimal.zero;
  }

  @action
  Decimal getPercentSymbol(String symbol) {
    final basePrice = getBasePriceBySymbol(symbol);
    final currentPrice = getPendingPriceBySymbol(symbol);
    if (basePrice == Decimal.zero || currentPrice == Decimal.zero) {
      return Decimal.zero;
    }

    final percentage =
        (Decimal.one - Decimal.fromJson('${(basePrice / currentPrice).toDouble()}')) * Decimal.fromInt(100);

    return percentage;
  }

  @action
  Decimal getProfitByPosition(InvestPositionModel position) {
    final instrument = instrumentsList.where((element) => element.symbol == position.symbol).toList();
    final price = pricesList.where((element) => element.symbol == position.symbol).toList();
    if (instrument.isEmpty || price.isEmpty) {
      return Decimal.zero;
    }

    if (position.status == PositionStatus.closed) {
      return position.direction == Direction.buy
          ? (position.closePrice! - position.openPrice!) * position.volumeBase! + position.rollOver! - position.openFee!
          : -(position.closePrice! - position.openPrice!) * position.volumeBase! +
              position.rollOver! -
              position.openFee!;
    }

    return position.direction == Direction.buy
        ? (price[0].lastPrice! - position.openPrice!) * position.volumeBase! + position.rollOver! - position.openFee!
        : -(price[0].lastPrice! - position.openPrice!) * position.volumeBase! + position.rollOver! - position.openFee!;
  }

  @action
  Decimal getMarketPLByPosition(InvestPositionModel position) {
    final instrument = instrumentsList.where((element) => element.symbol == position.symbol).toList();
    final price = pricesList.where((element) => element.symbol == position.symbol).toList();
    if (instrument.isEmpty || price.isEmpty) {
      return Decimal.zero;
    }

    if (position.status == PositionStatus.closed) {
      return position.direction == Direction.buy
          ? (position.closePrice! - position.openPrice!) * position.volumeBase!
          : -(position.closePrice! - position.openPrice!) * position.volumeBase!;
    }

    return position.direction == Direction.buy
        ? (price[0].lastPrice! - position.openPrice!) * position.volumeBase!
        : -(price[0].lastPrice! - position.openPrice!) * position.volumeBase!;
  }

  @action
  Decimal getYieldByPosition(InvestPositionModel position) {
    final instrument = instrumentsList.where((element) => element.symbol == position.symbol).toList();
    final price = pricesList.where((element) => element.symbol == position.symbol).toList();
    if (instrument.isEmpty || price.isEmpty) {
      return Decimal.zero;
    }

    var profit = position.direction == Direction.buy
        ? (Decimal.parse(price[0].lastPrice.toString()) - Decimal.parse(position.openPrice.toString())) *
                Decimal.parse(position.volumeBase.toString()) +
            Decimal.parse(position.rollOver.toString()) -
            Decimal.parse(position.openFee.toString())
        : -(Decimal.parse(price[0].lastPrice.toString()) - Decimal.parse(position.openPrice.toString())) *
                Decimal.parse(position.volumeBase.toString()) +
            Decimal.parse(position.rollOver.toString()) -
            Decimal.parse(position.openFee.toString());

    profit = Decimal.parse(profit.toStringAsFixed(2));

    final result = profit * Decimal.fromInt(100) / Decimal.parse(position.amount.toString());

    if (position.status == PositionStatus.closed) {
      final result = position.profitLoss! * Decimal.fromInt(100) / Decimal.parse(position.amount.toString());
      return Decimal.fromJson('${result.toDouble()}');
    }

    return Decimal.fromJson('${result.toDouble()}');
  }

  @action
  void setActiveSection(String id) {
    activeSection = id;
  }

  @action
  void setActiveSectionByIndex(int index) {
    activeSection = sections[index].id ?? '';
  }

  @action
  void onSearchInput(String value) {
    instrumentSearch = value;
  }

  @action
  void setInstrumentSort() {
    instrumentSort = instrumentSort == 2 ? 0 : instrumentSort + 1;
  }

  @action
  void setFavoritesSort() {
    favoritesSort = favoritesSort == 2 ? 0 : favoritesSort + 1;
  }

  @action
  void setFavoritesEditMode() {
    activeSection = 'all';
    _isFavoritesEditMode = !isFavoritesEditMode;
  }

  @action
  void setFavoritesEdit(bool newValue) {
    _isFavoritesEditMode = newValue;
  }

  @action
  void setShortDescription() {
    isShortDescription = !isShortDescription;
  }

  @action
  Future<void> resetFavorites() async {
    final newList = [
      'ETH',
      'BTC',
    ];

    await saveFavorites(newList);
  }

  @action
  Future<void> removeFromFavorites(String assetId) async {
    if (favoritesSymbols.length != 1) {
      final newList = [
        ...favoritesSymbols,
      ];
      newList.remove(assetId);

      await saveFavorites(newList);
    }
  }

  @action
  Future<void> addToFavorites(String assetId) async {
    final newList = [
      ...favoritesSymbols,
      assetId,
    ];
    favoritesSymbols.add(assetId);

    await saveFavorites(newList);
  }

  @action
  Future<void> saveFavorites(List<String> newList) async {
    await getIt.get<KeyValuesService>().addToKeyValue(
          KeyValueRequestModel(
            keys: [
              KeyValueResponseModel(
                key: favoritesInstrumentsKey,
                value: jsonEncode(newList),
              ),
            ],
          ),
        );
  }
}
