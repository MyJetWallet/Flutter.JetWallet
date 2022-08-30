import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/high_yield_buy/model/high_yield_buy_input.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/calculate_earn_offer_apy/calculate_earn_offer_apy_response_model.dart';

part 'high_yeild_buy_store.g.dart';

class HighYeildBuyStore extends _HighYeildBuyStoreBase
    with _$HighYeildBuyStore {
  HighYeildBuyStore(HighYieldBuyInput input) : super(input);

  static _HighYeildBuyStoreBase of(BuildContext context) =>
      Provider.of<HighYeildBuyStore>(context, listen: false);
}

abstract class _HighYeildBuyStoreBase with Store {
  _HighYeildBuyStoreBase(this.input) {
    _initCurrencies();
    _initBaseCurrency();
    updateSelectedCurrency(input.currency);
    calculateEarnOfferApy();

    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (updateApy) {
        updateApy = false;
        updatingNow = true;

        calculateEarnOfferApy();
      }
    });
  }

  final HighYieldBuyInput input;

  Timer _timer = Timer(Duration.zero, () {});

  static final _logger = Logger('HighYieldBuyStore');

  @observable
  Decimal? targetConversionPrice;

  @observable
  BaseCurrencyModel? baseCurrency;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  SKeyboardPreset? selectedPreset;

  @observable
  String? tappedPreset;

  @observable
  String inputValue = '0';

  @observable
  String targetConversionValue = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool inputValid = false;

  @observable
  List<CurrencyModel> currencies = ObservableList.of([]);

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
  Decimal? amountBaseAsset;

  @observable
  Decimal? currentBalanceBaseAsset;

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

  @observable
  bool error = false;

  @observable
  bool updateApy = false;

  @observable
  bool updatingNow = false;

  @computed
  String get selectedCurrencySymbol {
    return selectedCurrency == null
        ? baseCurrency!.symbol
        : selectedCurrency!.symbol;
  }

  @computed
  int get selectedCurrencyAccuracy {
    return selectedCurrency == null
        ? baseCurrency!.accuracy
        : selectedCurrency!.accuracy;
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
      prefix: baseCurrency?.prefix,
      decimal: Decimal.parse(baseConversionValue),
      symbol: baseCurrency!.symbol,
    );
  }

  @action
  void _initCurrencies() {
    final _currencies = List<CurrencyModel>.from(
      sCurrencies.currencies,
    );
    sortCurrencies(_currencies);
    removeCurrencyFrom(_currencies, input.currency);
    currencies = ObservableList.of(_currencies);
  }

  @action
  void _initBaseCurrency() {
    baseCurrency = sSignalRModules.baseCurrency;
  }

  @action
  void tapPreset(String presetName) {
    tappedPreset = presetName;
  }

  @action
  void updateSelectedCurrency(CurrencyModel? _currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    selectedCurrency = _currency;
    _validateInput();
  }

  @action
  void selectPercentFromBalance(SKeyboardPreset preset, {bool topUp = false}) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);
    final maxAvailable = Decimal.parse(
      '${input.earnOffer.maxAmount.toDouble() - input.earnOffer.amount.toDouble()}',
    );
    final percentageOfAll = valueBasedOnSelectedPercent(
      selected: percent,
      currency: input.currency,
    );

    final value = Decimal.parse(percentageOfAll) > maxAvailable
        ? maxAvailable
        : percentageOfAll;

    _updateInputValue(
      valueAccordingToAccuracy('$value', input.currency.accuracy),
    );
    if (inputError == InputError.amountTooLarge ||
        inputError == InputError.amountTooLow) {
      _updateInputValid(false);
    } else {
      _validateInput();
    }

    _calculateTargetConversion();
    _calculateBaseConversion();
  }

  @action
  void _updateSelectedPreset(SKeyboardPreset preset) {
    selectedPreset = preset;
  }

  @action
  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
  }

  @action
  void _updateInputValue(String value) {
    inputValue = value;
    updateApy = true;
  }

  @action
  void updateInputValue(String value) {
    _logger.log(notifier, 'updateInputValue');
    _validateInput();

    _updateInputValue(
      responseOnInputAction(
        oldInput: inputValue,
        newInput: value,
        accuracy: input.currency.accuracy,
      ),
    );
    if (inputError == InputError.amountTooLarge ||
        inputError == InputError.amountTooLow) {
      _updateInputValid(false);
    } else {
      _validateInput();
    }
    _calculateTargetConversion();
    _calculateBaseConversion();
    _clearPercent();
  }

  @action
  void _clearPercent() {
    selectedPreset = null;
  }

  @action
  Future<void> calculateEarnOfferApy() async {
    _logger.log(notifier, 'calculateEarnOfferApy');

    final model = CalculateEarnOfferApyRequestModel(
      offerId: input.earnOffer.offerId,
      assetSymbol: baseCurrency?.symbol ?? 'USD',
      amount: Decimal.parse(
        inputValue == '0' ? '0.0000000000001' : inputValue,
      ),
    );

    try {
      final response =
          await sNetwork.getWalletModule().postCalculateEarnOfferApy(model);

      response.pick(
        onData: (data) {
          offerId = data.offerId ?? '';
          tiers = ObservableList.of(data.tiers ?? []);
          amount = data.amount;
          apy = data.apy;
          currentApy = data.currentApy;
          currentBalance = data.currentBalance;
          expectedYearlyProfit = data.expectedYearlyProfit;
          expectedYearlyProfitBaseAsset = data.expectedYearlyProfitBaseAsset;
          amountTooLarge = data.amountTooLarge;
          maxSubscribeAmount = data.maxSubscribeAmount;
          amountTooLow = data.amountTooLow;
          minSubscribeAmount = data.minSubscribeAmount;
          error = false;
          updateApy = false;
          updatingNow = false;

          if (Decimal.parse(inputValue) > Decimal.zero) {
            if (data.amountTooLarge) {
              _updateInputError(InputError.amountTooLarge);
              _updateInputValid(false);
            } else if (data.amountTooLow) {
              _updateInputError(InputError.amountTooLow);
              _updateInputValid(false);
            } else {
              _updateInputError(InputError.none);
              _updateInputValid(true);
              _validateInput();
            }
          }
        },
        onError: (e) {
          _logger.log(stateFlow, 'calculateEarnOfferApy', e);

          error = true;
          updateApy = true;
        },
      );
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', e.cause);

      error = true;
      updateApy = true;
    } catch (e) {
      _logger.log(stateFlow, 'calculateEarnOfferApy', e);

      error = true;
      updateApy = true;
    }
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
    if ((targetConversionPrice != null || newPrice != null) &&
        inputValue.isNotEmpty) {
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

  @action
  void dispose() {
    _timer.cancel();
  }
}
