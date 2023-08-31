import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

part 'action_search_store.g.dart';

@lazySingleton
class ActionSearchStore = _ActionSearchStoreBase with _$ActionSearchStore;

abstract class _ActionSearchStoreBase with Store {
  _ActionSearchStoreBase() {
    init();
  }

  @observable
  ObservableList<MarketItemModel> marketCurrencies = ObservableList.of([]);

  @observable
  ObservableList<MarketItemModel> filteredMarketCurrencies =
      ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> filteredCurrencies = ObservableList.of([]);

  @computed
  List<CurrencyModel> get fCurrencies {
    if (searchValue.isEmpty) {
      return sSignalRModules.currenciesList;
    } else {
      var localCurr = sSignalRModules.currenciesList.toList();

      localCurr.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(searchValue) &&
            !element.symbol.toLowerCase().startsWith(searchValue);
      });

      return localCurr;
    }
  }

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> buyFromCardCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> receiveCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> sendCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> convertCurrenciesWithBalance =
      ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> convertCurrenciesWithoutBalance =
      ObservableList.of([]);

  @observable
  ObservableList<KycCountryModel> globalSendCountries = ObservableList.of([]);
  @observable
  ObservableList<KycCountryModel> filtredGlobalSendCountries =
      ObservableList.of([]);

  @observable
  ObservableList<PaymentAsset> newBuyPaymentCurrency = ObservableList.of([]);
  @observable
  ObservableList<PaymentAsset> filtredNewBuyPaymentCurrency =
      ObservableList.of([]);

  @observable
  String searchValue = '';
  @action
  void clearSearchValue() => searchValue = '';

  @observable
  bool showCrypto = true;

  @observable
  TextEditingController searchController = TextEditingController();

  @action
  void init() {
    final _currencies = sSignalRModules.currenciesList;
    final _buyFromCardCurrencies = <CurrencyModel>[];
    final _receiveCurrencies = <CurrencyModel>[];
    final _sendCurrencies = <CurrencyModel>[];

    for (final currency in _currencies) {
      if (currency.supportsAtLeastOneBuyMethod) {
        _buyFromCardCurrencies.add(currency);
      }
    }

    for (final currency in _currencies) {
      if (currency.type == AssetType.crypto && currency.supportsCryptoDeposit) {
        _receiveCurrencies.add(currency);
      }
    }

    for (final currency in _currencies) {
      if (currency.isAssetBalanceNotEmpty &&
          currency.supportsCryptoWithdrawal) {
        _sendCurrencies.add(currency);
      }
    }

    currencies = ObservableList.of(_currencies);
    filteredCurrencies = ObservableList.of(_currencies);
    buyFromCardCurrencies = ObservableList.of(_buyFromCardCurrencies);
    receiveCurrencies = ObservableList.of(_receiveCurrencies);
    sendCurrencies = ObservableList.of(_sendCurrencies);
    search(searchValue);
  }

  @action
  void globalSendSearchInit(List<KycCountryModel> availableCountries) {
    availableCountries.sort((a, b) => a.countryName.compareTo(b.countryName));

    globalSendCountries = ObservableList.of(availableCountries.toList());
    filtredGlobalSendCountries = ObservableList.of(availableCountries.toList());
  }

  @action
  void newBuySearchInit(List<PaymentAsset> availablyCurrency) {
    //availablyCurrency.sort((a, b) => a.countryName.compareTo(b.countryName));

    newBuyPaymentCurrency = ObservableList.of(availablyCurrency.toList());
    filtredNewBuyPaymentCurrency =
        ObservableList.of(availablyCurrency.toList());
  }

  @action
  void globalSendSearch(String value) {
    final search = value.toLowerCase();

    if (search.isEmpty) {
      filtredGlobalSendCountries =
          ObservableList.of(globalSendCountries.toList());
    } else {
      filtredGlobalSendCountries.removeWhere((element) {
        return !element.countryName.toLowerCase().startsWith(search);
      });
    }
  }

  @action
  void newBuySearch(String value) {
    final search = value.toLowerCase();

    if (search.isEmpty) {
      print(search.isEmpty);

      filtredNewBuyPaymentCurrency = ObservableList.of(
        newBuyPaymentCurrency.toList(),
      );
    } else {
      filtredNewBuyPaymentCurrency.removeWhere((element) {
        final curr = getIt.get<FormatService>().findCurrency(
              findInHideTerminalList: true,
              assetSymbol: element.asset,
            );

        return !element.asset.toLowerCase().startsWith(search) &&
            !curr.description.toLowerCase().startsWith(search);
      });
    }
  }

  @action
  void refreshSearch() {
    searchValue = '';
    search(searchValue);
  }

  @action
  void initMarket() {
    final _currencies = sSignalRModules.getMarketPrices;

    marketCurrencies = ObservableList.of(_currencies);
    filteredMarketCurrencies = ObservableList.of(marketCurrencies);
  }

  @action
  void initConvert(
    List<CurrencyModel> assetsWithBalance,
    List<CurrencyModel> assetsWithoutBalance,
  ) {
    convertCurrenciesWithBalance = ObservableList.of(assetsWithBalance);
    convertCurrenciesWithoutBalance = ObservableList.of(assetsWithoutBalance);
  }

  @action
  void search(String value) {
    if (value.isNotEmpty && currencies.isNotEmpty) {
      final search = value.toLowerCase();
      searchValue = search;
      final _buyFromCardCurrencies = <CurrencyModel>[];

      final _currencies = List<CurrencyModel>.from(currencies);

      _currencies.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });

      for (final element in _currencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          _buyFromCardCurrencies.add(element);
        }
      }

      //fCurrencies = ObservableList.of(_currencies);
      buyFromCardCurrencies = ObservableList.of(_buyFromCardCurrencies);
    } else if (value.isEmpty) {
      searchValue = '';

      final _currencies = List<CurrencyModel>.from(currencies);
      final _buyFromCardCurrencies = <CurrencyModel>[];

      for (final element in _currencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          _buyFromCardCurrencies.add(element);
        }
      }

      //fCurrencies = ObservableList.of(_currencies);
      buyFromCardCurrencies = ObservableList.of(_buyFromCardCurrencies);
    }
  }

  @action
  void searchConvert(
    String value,
    List<CurrencyModel> assetsWithBalance,
    List<CurrencyModel> assetsWithoutBalance,
  ) {
    if (value.isNotEmpty && assetsWithBalance.isNotEmpty) {
      final search = value.toLowerCase();

      final _currencies = List<CurrencyModel>.from(assetsWithBalance);

      _currencies.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });
      convertCurrenciesWithBalance = ObservableList.of(_currencies);
    }
    if (value.isNotEmpty && assetsWithoutBalance.isNotEmpty) {
      final search = value.toLowerCase();

      final _currencies = List<CurrencyModel>.from(assetsWithoutBalance);

      _currencies.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });
      convertCurrenciesWithoutBalance = ObservableList.of(_currencies);
    }
    if (value.isEmpty) {
      convertCurrenciesWithBalance = ObservableList.of(assetsWithBalance);
      convertCurrenciesWithoutBalance = ObservableList.of(assetsWithoutBalance);
    }
  }

  @action
  void searchMarket(
    String value,
  ) {
    searchValue = value;
    if (value.isNotEmpty && currencies.isNotEmpty) {
      final search = value.toLowerCase();

      final _currencies = List<MarketItemModel>.from(marketCurrencies);

      _currencies.removeWhere((element) {
        return !element.name.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });
      filteredMarketCurrencies = ObservableList.of(_currencies);
    } else if (value.isEmpty) {
      final _currencies = List<MarketItemModel>.from(marketCurrencies);
      filteredMarketCurrencies = ObservableList.of(_currencies);
    }
  }

  @action
  void updateShowCrypto(
    bool value,
  ) {
    showCrypto = value;
  }
}
