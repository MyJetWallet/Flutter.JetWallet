import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/return_to_wallet/model/return_to_wallet_input.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/calculate_earn_offer_apy/calculate_earn_offer_apy_response_model.dart';

part 'return_to_wallet_store.g.dart';

class ReturnToWalletStore extends _ReturnToWalletStoreBase with _$ReturnToWalletStore {
  ReturnToWalletStore(super.input);

  static _ReturnToWalletStoreBase of(BuildContext context) => Provider.of<ReturnToWalletStore>(context, listen: false);
}

abstract class _ReturnToWalletStoreBase with Store {
  _ReturnToWalletStoreBase(this.input) {
    _initCurrencies();
    _initBaseCurrency();
    updateSelectedCurrency(input.currency);
    initBaseData();
  }

  final ReturnToWalletInput input;

  static final _logger = Logger('ReturnToWalletStore');

  @observable
  Decimal? targetConversionPrice;

  @observable
  BaseCurrencyModel? baseCurrency;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  String inputValue = '0';

  @observable
  String targetConversionValue = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool inputValid = false;

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  InputError inputError = InputError.none;

  @observable
  String offerId = '';

  @observable
  ObservableList<TierModel> tiers = ObservableList.of([]);

  @observable
  Decimal? amount;

  @observable
  Decimal? apy;

  @observable
  Decimal? currentApy;

  @observable
  Decimal? currentBalance;

  @observable
  Decimal? expectedYearlyProfit;

  @observable
  Decimal? expectedYearlyProfitBaseAsset;

  @observable
  bool amountTooLarge = false;

  @observable
  bool amountTooLow = false;

  @observable
  Decimal? maxSubscribeAmount;

  @observable
  Decimal? minSubscribeAmount;

  @computed
  String get selectedCurrencySymbol {
    return selectedCurrency == null ? baseCurrency!.symbol : selectedCurrency!.symbol;
  }

  @computed
  int get selectedCurrencyAccuracy {
    return selectedCurrency == null ? baseCurrency!.accuracy : selectedCurrency!.accuracy;
  }

  @computed
  bool get singleTier => simpleTiers.length == 1;

  @computed
  List<SimpleTierModel> get simpleTiers => tiers
      .map(
        (tier) => SimpleTierModel(
          active: tier.active,
          to: tier.to.toString(),
          from: tier.from.toString(),
          apy: tier.apy.toString(),
        ),
      )
      .toList();

  @action
  String conversionText() {
    return marketFormat(
      accuracy: baseCurrency!.accuracy,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );
  }

  @action
  void _initCurrencies() {
    final tempCurrencies = List<CurrencyModel>.from(
      sSignalRModules.currenciesList,
    );
    sortCurrencies(tempCurrencies);

    removeCurrencyFrom(tempCurrencies, input.currency);

    currencies = ObservableList.of(tempCurrencies);
  }

  void _initBaseCurrency() {
    baseCurrency = sSignalRModules.baseCurrency;
  }

  @action
  Future<void> initBaseData() async {
    _logger.log(notifier, 'initBaseData');

    offerId = input.earnOffer.offerId;
    amount = input.earnOffer.amount;
    apy = input.earnOffer.currentApy;
    currentApy = input.earnOffer.currentApy;
    currentBalance = input.earnOffer.amount;
  }

  @action
  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    selectedCurrency = currency;
    _validateInput();
  }

  @action
  void _updateInputValue(String value) {
    inputValue = value;
  }

  @action
  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');

    _updateInputValue(
      responseOnInputAction(
        oldInput: inputValue,
        newInput: value,
        accuracy: input.currency.accuracy,
      ),
    );

    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  void pasteValue(String value) {
    _logger.log(notifier, 'pasteValue');

    _updateInputValue(value);

    _validateInput();
    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  void updateTargetConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateTargetConversionPrice');

    // needed to calculate conversion while switching between assets
    _calculateTargetConversion(price);
    targetConversionPrice = price;
  }

  @action
  void _updateTargetConversionValue(String value) {
    targetConversionValue = value;
  }

  @action
  void _calculateTargetConversion([Decimal? newPrice]) {
    if ((targetConversionPrice != null || newPrice != null) && inputValue.isNotEmpty) {
      final amount = Decimal.parse(inputValue);
      final price = newPrice ?? targetConversionPrice!;
      final accuracy = selectedCurrencyAccuracy;

      final conversion = amount * price;

      _updateTargetConversionValue(
        truncateZerosFrom(
          conversion.toStringAsFixed(accuracy),
        ),
      );
    } else {
      _updateTargetConversionValue(zero);
    }
  }

  @action
  void _updateBaseConversionValue(String value) {
    baseConversionValue = value;
  }

  @action
  void _calculateBaseConversion() {
    if (inputValue.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: input.currency.symbol,
        assetBalance: Decimal.parse(inputValue),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  @action
  void _updateInputValid(bool value) {
    inputValid = value;
  }

  @action
  void _updateInputError(InputError error) {
    inputError = error;
  }

  @action
  void _validateInput() {
    final error = onTradeInputErrorHandler(
      inputValue,
      input.currency,
      availableBalance: currentBalance,
    );

    if (selectedCurrency == null) {
      _updateInputValid(false);
    } else {
      if (error == InputError.none) {
        _updateInputValid(
          isInputValid(inputValue),
        );
      } else {
        _updateInputValid(false);
      }
    }

    _updateInputError(error);
  }
}
