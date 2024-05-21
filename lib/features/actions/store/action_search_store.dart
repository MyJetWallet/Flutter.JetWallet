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
  ObservableList<MarketItemModel> filteredMarketCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> filteredCurrencies = ObservableList.of([]);

  @computed
  List<CurrencyModel> get fCurrencies {
    if (searchValue.isEmpty) {
      return currencies;
    } else {
      final localCurr = currencies.toList();

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
  ObservableList<CurrencyModel> searchCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> buyFromCardCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> receiveCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> sendCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> convertCurrenciesWithBalance = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> convertCurrenciesWithoutBalance = ObservableList.of([]);

  @observable
  ObservableList<KycCountryModel> globalSendCountries = ObservableList.of([]);
  @observable
  ObservableList<KycCountryModel> filtredGlobalSendCountries = ObservableList.of([]);

  @observable
  ObservableList<PaymentAsset> newBuyPaymentCurrency = ObservableList.of([]);
  @observable
  ObservableList<PaymentAsset> filtredNewBuyPaymentCurrency = ObservableList.of([]);

  @observable
  String searchValue = '';
  @action
  void clearSearchValue() => searchValue = '';

  @observable
  bool showCrypto = true;

  @observable
  TextEditingController searchController = TextEditingController();

  @action
  void init({
    List<CurrencyModel>? customCurrencies,
  }) {
    searchValue = '';
    final tempCurrencies = customCurrencies ?? sSignalRModules.currenciesList;
    final tempBuyFromCardCurrencies = <CurrencyModel>[];
    final tempReceiveCurrencies = <CurrencyModel>[];
    final tempSendCurrencies = <CurrencyModel>[];

    for (final currency in tempCurrencies) {
      if (currency.supportsAtLeastOneBuyMethod) {
        tempBuyFromCardCurrencies.add(currency);
      }
    }

    for (final currency in tempCurrencies) {
      if (currency.type == AssetType.crypto && currency.supportsCryptoDeposit) {
        tempReceiveCurrencies.add(currency);
      }
    }

    for (final currency in tempCurrencies) {
      if (currency.isAssetBalanceNotEmpty && currency.supportsCryptoWithdrawal) {
        tempSendCurrencies.add(currency);
      }
    }

    currencies = ObservableList.of(tempCurrencies);
    searchCurrencies = ObservableList.of(tempCurrencies);
    filteredCurrencies = ObservableList.of(tempCurrencies);
    buyFromCardCurrencies = ObservableList.of(tempBuyFromCardCurrencies);
    receiveCurrencies = ObservableList.of(tempReceiveCurrencies);
    sendCurrencies = ObservableList.of(tempSendCurrencies);

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
    filtredNewBuyPaymentCurrency = ObservableList.of(availablyCurrency.toList());
  }

  @action
  void globalSendSearch(String value) {
    final search = value.toLowerCase();

    if (search.isEmpty) {
      filtredGlobalSendCountries = ObservableList.of(globalSendCountries.toList());
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
      filtredNewBuyPaymentCurrency = ObservableList.of(
        newBuyPaymentCurrency.toList(),
      );
    } else {
      filtredNewBuyPaymentCurrency.removeWhere((element) {
        final curr = getIt.get<FormatService>().findCurrency(
              findInHideTerminalList: true,
              assetSymbol: element.asset,
            );

        return !element.asset.toLowerCase().startsWith(search) && !curr.description.toLowerCase().startsWith(search);
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
    final currencies = sSignalRModules.getMarketPrices;

    marketCurrencies = ObservableList.of(currencies);
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
      final tempBuyFromCardCurrencies = <CurrencyModel>[];

      final tempCurrencies = List<CurrencyModel>.from(currencies);

      tempCurrencies.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });

      for (final element in tempCurrencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          tempBuyFromCardCurrencies.add(element);
        }
      }

      searchCurrencies = ObservableList.of(tempCurrencies);

      //fCurrencies = ObservableList.of(_currencies);
      buyFromCardCurrencies = ObservableList.of(tempBuyFromCardCurrencies);
    } else if (value.isEmpty) {
      searchValue = '';

      final tempCurrencies = List<CurrencyModel>.from(currencies);
      final tempBuyFromCardCurrencies = <CurrencyModel>[];

      for (final element in tempCurrencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          tempBuyFromCardCurrencies.add(element);
        }
      }

      searchCurrencies = ObservableList.of(tempCurrencies);

      //fCurrencies = ObservableList.of(_currencies);
      buyFromCardCurrencies = ObservableList.of(tempBuyFromCardCurrencies);
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

      final tempCurrencies = List<CurrencyModel>.from(assetsWithBalance);

      tempCurrencies.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });
      convertCurrenciesWithBalance = ObservableList.of(tempCurrencies);
    }
    if (value.isNotEmpty && assetsWithoutBalance.isNotEmpty) {
      final search = value.toLowerCase();

      final tempCurrencies = List<CurrencyModel>.from(assetsWithoutBalance);

      tempCurrencies.removeWhere((element) {
        return !element.description.toLowerCase().startsWith(search) &&
            !element.symbol.toLowerCase().startsWith(search);
      });
      convertCurrenciesWithoutBalance = ObservableList.of(tempCurrencies);
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

      final tempCurrencies = List<MarketItemModel>.from(marketCurrencies);

      tempCurrencies.removeWhere((element) {
        return !element.name.toLowerCase().startsWith(search) && !element.symbol.toLowerCase().startsWith(search);
      });
      filteredMarketCurrencies = ObservableList.of(tempCurrencies);
    } else if (value.isEmpty) {
      final tempCurrencies = List<MarketItemModel>.from(marketCurrencies);
      filteredMarketCurrencies = ObservableList.of(tempCurrencies);
    }
  }

  @action
  void updateShowCrypto(
    bool value,
  ) {
    showCrypto = value;
  }
}
