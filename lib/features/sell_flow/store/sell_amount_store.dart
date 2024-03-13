import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/sell_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/swap_limits_request_model.dart';
part 'sell_amount_store.g.dart';

class SellAmountStore extends _SellAmountStoreBase with _$SellAmountStore {
  SellAmountStore() : super();

  static SellAmountStore of(BuildContext context) => Provider.of<SellAmountStore>(context, listen: false);
}

abstract class _SellAmountStoreBase with Store {
  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: fiatSymbol,
      );

  @computed
  PaymentMethodCategory get category {
    return account != null
        ? PaymentMethodCategory.account
        : card != null
            ? PaymentMethodCategory.simpleCard
            : PaymentMethodCategory.none;
  }

  @observable
  bool disableSubmit = false;
  @action
  bool setDisableSubmit(bool value) => disableSubmit = value;

  @observable
  String? paymentMethodInputError;

  @observable
  Decimal? targetConversionPrice;

  @computed
  bool get isContinueAvaible {
    return inputValid &&
        Decimal.parse(primaryAmount) != Decimal.zero &&
        (account != null || card != null) &&
        asset != null;
  }

  @observable
  InputError inputError = InputError.none;

  @observable
  String? errorText;

  @observable
  bool inputValid = false;

  @observable
  bool isFiatEntering = true;

  @observable
  String fiatInputValue = '0';

  @observable
  String cryptoInputValue = '0';

  @computed
  String get cryptoSymbol => asset?.symbol ?? '';

  @computed
  String get fiatSymbol {
    return 'EUR';
  }

  @computed
  String get primaryAmount {
    return isFiatEntering ? fiatInputValue : cryptoInputValue;
  }

  @computed
  String get primarySymbol {
    return isFiatEntering ? fiatSymbol : cryptoSymbol;
  }

  @computed
  String get secondaryAmount {
    return isFiatEntering ? cryptoInputValue : fiatInputValue;
  }

  @computed
  String get secondarySymbol {
    return isFiatEntering ? cryptoSymbol : fiatSymbol;
  }

  @computed
  int get primaryAccuracy {
    return isFiatEntering ? buyCurrency.accuracy : asset?.accuracy ?? 2;
  }

  @computed
  int get secondaryAccuracy {
    return isFiatEntering ? asset?.accuracy ?? 2 : buyCurrency.accuracy;
  }

  @computed
  String get fiatBalance {
    return account?.currency ?? card?.currency ?? '';
  }

  @observable
  PaymentAsset? paymentAsset;

  @observable
  CurrencyModel? asset;

  @observable
  SimpleBankingAccount? account;

  @observable
  CardDataModel? card;

  @observable
  bool isNoCurrencies = false;

  @observable
  bool isNoAccounts = false;

  @action
  void _checkShowTosts() {
    isNoCurrencies = !sSignalRModules.currenciesList.any((currency) {
      return currency.assetBalance != Decimal.zero && currency.symbol != 'EUR';
    });
    isNoAccounts = !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false);

    final isCryptoBalanceEmpty = asset?.isAssetBalanceEmpty ?? false;
    Timer(
      const Duration(milliseconds: 200),
      () {
        if (isNoCurrencies && isNoAccounts) {
          sNotification.showError(
            intl.tost_sell_message_1,
            id: 1,
          );
        } else if (isNoCurrencies) {
          sNotification.showError(
            intl.tost_sell_message_2,
            id: 2,
            isError: false,
          );
        } else if (isNoAccounts) {
          sNotification.showError(
            intl.tost_sell_message_3,
            id: 3,
          );
          sAnalytics.errorYouNeedToCreateEURAccountFirst();
        } else if (isCryptoBalanceEmpty) {
          sNotification.showError(
            intl.error_message_insufficient_funds,
            id: 1,
            isError: false,
          );
        }
      },
    );
  }

  @action
  void init({
    CurrencyModel? inputAsset,
    SimpleBankingAccount? newAccount,
    CardDataModel? newCard,
  }) {
    asset = inputAsset;
    account = newAccount;
    card = newCard;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    loadLimits();

    _checkShowTosts();
  }

  @action
  void setNewAsset(CurrencyModel newAsset) {
    asset = newAsset;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );
    loadLimits();

    fiatInputValue = '0';

    cryptoInputValue = '0';
    errorText = null;

    inputValid = false;
  }

  @action
  void setNewPayWith({
    SimpleBankingAccount? newAccount,
    CardDataModel? newCard,
  }) {
    if (newAccount != null) {
      account = newAccount;
      card = null;
    }

    if (newCard != null) {
      account = null;
      card = newCard;
    }

    paymentAsset = null;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );
    loadLimits();

    fiatInputValue = '0';

    cryptoInputValue = '0';
    errorText = null;
    _validateInput();
  }

  @action
  Future<void> loadConversionPrice(
    String baseS,
    String targetS,
  ) async {
    if (asset != null) {
      targetConversionPrice = await getConversionPrice(
        ConversionPriceInput(
          baseAssetSymbol: baseS,
          quotedAssetSymbol: targetS,
        ),
      );
    }
  }

  @action
  void onSwap() {
    isFiatEntering = !isFiatEntering;
    _cutUnnecessaryAccuracy();
    _validateInput();
  }

  @action
  void _cutUnnecessaryAccuracy() {
    if (isFiatEntering) {
      fiatInputValue = Decimal.parse(fiatInputValue).floor(scale: buyCurrency.accuracy).toString();
    } else {
      cryptoInputValue = Decimal.parse(cryptoInputValue).floor(scale: asset?.accuracy ?? 2).toString();
    }
  }

  @computed
  String get inputErrorValue {
    return paymentMethodInputError != null ? paymentMethodInputError! : inputError.value();
  }

  @computed
  bool get isInputErrorActive {
    return inputError.isActive || paymentMethodInputError != null;
  }

  @computed
  int get fiatAccuracy {
    return sSignalRModules.currenciesList.firstWhere((element) => element.symbol == fiatSymbol).accuracy;
  }

  @computed
  Decimal get sellAllValue {
    return asset?.assetBalance ?? Decimal.zero;
  }

  @action
  void onSellAll() {
    cryptoInputValue = responseOnInputAction(
      oldInput: cryptoInputValue,
      newInput: sellAllValue.toString(),
      accuracy: asset?.accuracy ?? 2,
    );

    isFiatEntering = false;

    _calculateFiatConversion();

    _validateInput();
  }

  @action
  void updateInputValue(String value) {
    if (isFiatEntering) {
      fiatInputValue = responseOnInputAction(
        oldInput: fiatInputValue,
        newInput: value,
        accuracy: fiatAccuracy,
        wholePartLenght: maxWholePrartLenght,
      );
    } else {
      cryptoInputValue = responseOnInputAction(
        oldInput: cryptoInputValue,
        newInput: value,
        accuracy: asset?.accuracy ?? 2,
        wholePartLenght: maxWholePrartLenght,
      );
    }
    if (isFiatEntering) {
      _calculateCryptoConversion();
    } else {
      _calculateFiatConversion();
    }

    _validateInput();
  }

  @action
  void pasteValue(String value) {
    if (isFiatEntering) {
      fiatInputValue = value;
    } else {
      cryptoInputValue = value;
    }
    if (isFiatEntering) {
      _calculateCryptoConversion();
    } else {
      _calculateFiatConversion();
    }

    _validateInput();
  }

  @action
  void _calculateCryptoConversion() {
    if (targetConversionPrice != null && fiatInputValue != '0') {
      final amount = Decimal.parse(fiatInputValue);
      final price = targetConversionPrice!;
      final accuracy = asset!.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        conversion = Decimal.parse(
          (amount * price).toStringAsFixed(accuracy),
        );
      }

      cryptoInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      cryptoInputValue = zero;
    }
  }

  void _calculateFiatConversion() {
    if (targetConversionPrice != null && cryptoInputValue != '0') {
      final amount = Decimal.parse(cryptoInputValue);
      final price = targetConversionPrice!;
      final accuracy = asset!.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        final koef = amount.toDouble() / price.toDouble();
        conversion = Decimal.parse(
          koef.toStringAsFixed(accuracy),
        );
      }

      fiatInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      fiatInputValue = zero;
    }
  }

  @observable
  Decimal _minSellAmount = Decimal.zero;

  @observable
  Decimal _maxSellAmount = Decimal.zero;

  @observable
  Decimal _minBuyAmount = Decimal.zero;

  @observable
  Decimal _maxBuyAmount = Decimal.zero;

  @computed
  Decimal get minLimit {
    return isFiatEntering ? _minBuyAmount : _minSellAmount;
  }

  @computed
  Decimal get maxLimit {
    return isFiatEntering ? _maxBuyAmount : _maxSellAmount;
  }

  @computed
  int get maxWholePrartLenght =>
      (isBothAssetsSeted && maxLimit != Decimal.zero) ? (maxLimit.round().toString().length + 1) : 15;

  @computed
  bool get isBothAssetsSeted => (account != null || card != null) && asset != null;

  @computed
  String get accountId => account?.accountId ?? card?.cardId ?? '';

  @action
  Future<void> loadLimits() async {
    if (category == PaymentMethodCategory.none || asset == null) {
      return;
    }

    _minSellAmount = Decimal.zero;
    _maxSellAmount = Decimal.zero;
    _minBuyAmount = Decimal.zero;
    _maxBuyAmount = Decimal.zero;

    try {
      if (account?.accountId == 'clearjuction_account') {
        final model = SwapLimitsRequestModel(
          fromAsset: asset?.symbol ?? '',
          toAsset: fiatSymbol,
        );
        final response = await sNetwork.getWalletModule().postSwapLimits(model);
        response.pick(
          onData: (data) {
            _minSellAmount = data.minFromAssetVolume;
            _maxSellAmount = data.maxFromAssetVolume;
            _minBuyAmount = data.minToAssetVolume;
            _maxBuyAmount = data.maxToAssetVolume;
          },
          onError: (error) {
            sNotification.showError(
              error.cause,
              id: 1,
              needFeedback: true,
            );
          },
        );
      } else {
        final model = SellLimitsRequestModel(
          paymentAsset: asset?.symbol ?? '',
          buyAsset: fiatSymbol,
          destinationAccountId: accountId,
        );
        final response = await sNetwork.getWalletModule().postSellLimits(model);
        response.pick(
          onData: (data) {
            _minSellAmount = data.minSellAmount;
            _maxSellAmount = data.maxSellAmount;
            _minBuyAmount = data.minBuyAmount;
            _maxBuyAmount = data.maxBuyAmount;
          },
          onError: (error) {
            sNotification.showError(
              error.cause,
              id: 1,
              needFeedback: true,
            );
          },
        );
      }
      _validateInput();
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    }
  }

  @action
  void _validateInput() {
    if (Decimal.parse(primaryAmount) == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(primaryAmount)) {
      inputValid = false;

      return;
    }

    if (maxLimit == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    final value = Decimal.parse(primaryAmount);

    inputValid = value >= minLimit && value <= maxLimit;

    if (maxLimit == Decimal.zero) {
      _updatePaymentMethodInputError(
        null,
      );
    } else if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: minLimit,
          accuracy: primaryAccuracy,
          symbol: primarySymbol,
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: maxLimit,
          accuracy: primaryAccuracy,
          symbol: primarySymbol,
        )}',
      );
    } else {
      _updatePaymentMethodInputError(null);
    }

    const error = InputError.none;

    inputError = double.parse(primaryAmount) != 0
        ? error == InputError.none
            ? paymentMethodInputError == null
                ? InputError.none
                : InputError.limitError
            : error
        : InputError.none;
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    if (error != null) {
      sAnalytics.errorShowingErrorUnderSellAmount();
    }
    paymentMethodInputError = error;
  }
}
