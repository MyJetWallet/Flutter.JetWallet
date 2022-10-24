import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

part 'nft_sell_store.g.dart';

class NFTSellStore extends _NFTSellStoreBase with _$NFTSellStore {
  NFTSellStore() : super();

  static _NFTSellStoreBase of(BuildContext context) =>
      Provider.of<NFTSellStore>(context, listen: false);
}

abstract class _NFTSellStoreBase with Store {
  NftMarket? nft;

  @observable
  BaseCurrencyModel baseCurrency = sSignalRModules.baseCurrency;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  bool inputValid = false;

  @observable
  String inputValue = '0';

  @observable
  String targetConversionValue = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  InputError inputError = InputError.none;

  @action
  String conversionText() {
    final val = volumeFormat(
      accuracy: baseCurrency.accuracy,
      prefix: baseCurrency.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency.symbol,
    );

    return val;
  }

  @action
  void init(NftMarket value) {
    nft = value;

    initCurrencies();

    selectedCurrency = currencyFrom(
      sSignalRModules.currenciesList,
      value.tradingAsset ?? '',
    );

    print(selectedCurrency);
  }

  @action
  void initCurrencies() {
    final _currencies = List<CurrencyModel>.from(
      sSignalRModules.currenciesList,
    );
    sortCurrencies(_currencies);

    currencies = ObservableList.of(_currencies);
  }

  @action
  void updateInputValue(String value) {
    inputValue = responseOnInputAction(
      oldInput: inputValue,
      newInput: value,
      accuracy: selectedCurrency!.accuracy,
    );

    inputValid = inputValue != '0' && inputValue.isNotEmpty ? true : false;

    _calculateBaseConversion();
  }

  @action
  void updateSelectedCurrency(CurrencyModel? currency) {
    selectedCurrency = currency;

    _calculateBaseConversion();
  }

  @action
  void _updateTargetConversionValue(String value) {
    targetConversionValue = value;
  }

  @action
  void _updateBaseConversionValue(String value) {
    baseConversionValue = value;
  }

  @action
  void _calculateBaseConversion() {
    if (inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: selectedCurrency?.symbol ?? '',
        assetBalance: Decimal.parse(inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }
}
