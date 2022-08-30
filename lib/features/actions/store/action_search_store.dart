import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

part 'action_search_store.g.dart';

@lazySingleton
class ActionSearchStore = _ActionSearchStoreBase with _$ActionSearchStore;

abstract class _ActionSearchStoreBase with Store {
  _ActionSearchStoreBase() {
    init();
  }

  @observable
  ObservableList<CurrencyModel> filteredCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> buyFromCardCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> receiveCurrencies = ObservableList.of([]);

  @observable
  ObservableList<CurrencyModel> sendCurrencies = ObservableList.of([]);

  @action
  void init() {
    final _currencies = getIt.get<CurrenciesService>().currencies;
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
  }

  @action
  void search(String value) {
    if (value.isNotEmpty && currencies.isNotEmpty) {
      final search = value.toLowerCase();
      final _buyFromCardCurrencies = <CurrencyModel>[];

      final _currencies = List<CurrencyModel>.from(currencies);

      _currencies.removeWhere((element) {
        return !(element.description.toLowerCase()).startsWith(search) &&
            !(element.symbol.toLowerCase()).startsWith(search);
      });

      for (final element in _currencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          _buyFromCardCurrencies.add(element);
        }
      }

      filteredCurrencies = ObservableList.of(_currencies);
      buyFromCardCurrencies = ObservableList.of(_buyFromCardCurrencies);
    } else if (value.isEmpty) {
      final _currencies = List<CurrencyModel>.from(currencies);
      final _buyFromCardCurrencies = <CurrencyModel>[];

      for (final element in _currencies) {
        if (element.supportsAtLeastOneBuyMethod) {
          _buyFromCardCurrencies.add(element);
        }
      }

      filteredCurrencies = ObservableList.of(_currencies);
      buyFromCardCurrencies = ObservableList.of(_buyFromCardCurrencies);
    }
  }
}
