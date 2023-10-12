import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
part 'amount_store.g.dart';

class BuyAmountStore extends _BuyAmountStoreBase with _$BuyAmountStore {
  BuyAmountStore() : super();

  static BuyAmountStore of(BuildContext context) => Provider.of<BuyAmountStore>(context, listen: false);
}

abstract class _BuyAmountStoreBase with Store {
  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: fiatSymbol,
      );

  @observable
  PaymentMethodCategory category = PaymentMethodCategory.cards;

  @observable
  bool disableSubmit = false;
  @action
  bool setDisableSubmit(bool value) => disableSubmit = value;

  @observable
  String? paymentMethodInputError;

  @observable
  Decimal? targetConversionPrice;

  @observable
  InputError inputError = InputError.none;

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
    return category == PaymentMethodCategory.cards ? card?.cardAssetSymbol ?? '' : account?.currency ?? '';
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
  String get fiatBalance {
    return category == PaymentMethodCategory.cards ? card?.toString() ?? '' : account?.currency ?? '';
  }

  @observable
  CurrencyModel? asset;

  @observable
  BuyMethodDto? method;

  @observable
  CircleCard? card;

  @observable
  SimpleBankingAccount? account;

  @action
  void init({
    required CurrencyModel inputAsset,
    BuyMethodDto? inputMethod,
    CircleCard? inputCard,
    SimpleBankingAccount? account,
    required bool showUaAlert,
  }) {
    asset = inputAsset;
    method = inputMethod;
    card = inputCard;
    this.account = account;

    category = inputCard != null ? PaymentMethodCategory.cards : PaymentMethodCategory.account;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    Timer(
      const Duration(milliseconds: 500),
      () {
        if ((inputCard != null && inputCard.showUaAlert) || showUaAlert) {
          sShowAlertPopup(
            sRouter.navigatorKey.currentContext!,
            primaryText: intl.currencyBuy_alert,
            secondaryText: intl.currencyBuy_alertDescription,
            primaryButtonName: intl.actionBuy_gotIt,
            image: Image.asset(
              phoneChangeAsset,
              width: 80,
              height: 80,
              package: 'simple_kit',
            ),
            onPrimaryButtonTap: () {
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
          );
        }
      },
    );

    sAnalytics.newBuyBuyAssetView(
      asset: asset?.symbol ?? '',
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : inputMethod!.id.name,
      paymentMethodCurrency: buyCurrency.symbol,
    );
  }

  @action
  void setNewAsset(CurrencyModel newAsset) {
    asset = newAsset;

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    fiatInputValue = '0';

    cryptoInputValue = '0';
    inputValid = false;
  }

  void setNewPayWith({
    CircleCard? newCard,
    SimpleBankingAccount? newAccount,
  }) {
    if (newCard != null) {
      card = newCard;
      account = null;
      category = PaymentMethodCategory.cards;
    }
    if (newAccount != null) {
      account = newAccount;
      card = null;
      category = PaymentMethodCategory.account;
    }

    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );

    fiatInputValue = '0';

    cryptoInputValue = '0';
    inputValid = false;
  }

  @action
  Future<void> loadConversionPrice(
    String baseS,
    String targetS,
  ) async {
    targetConversionPrice = await getConversionPrice(
      ConversionPriceInput(
        baseAssetSymbol: baseS,
        quotedAssetSymbol: targetS,
      ),
    );
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
  int get selectedCurrencyAccuracy {
    return asset == null ? baseCurrency.accuracy : buyCurrency.accuracy;
  }

  @action
  void updateInputValue(String value) {
    if (isFiatEntering) {
      fiatInputValue = responseOnInputAction(
        oldInput: fiatInputValue,
        newInput: value,
        accuracy: selectedCurrencyAccuracy,
      );
    } else {
      cryptoInputValue = responseOnInputAction(
        oldInput: cryptoInputValue,
        newInput: value,
        accuracy: selectedCurrencyAccuracy,
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

  @action
  void _validateInput() {
    inputValid = Decimal.parse(fiatInputValue) != Decimal.zero;
    // if (double.parse(inputValue) == 0.0) {
    //   inputValid = true;
    //   inputError = InputError.none;
    //   _updatePaymentMethodInputError(null);

    //   return;
    // }
    // if (method != null) {
    //   if (!isInputValid(inputValue)) {
    //     inputValid = false;

    //     return;
    //   }

    //   final value = double.parse(inputValue);
    //   final min = double.parse('${asset?.minTradeAmount ?? 0}');
    //   var max = double.parse('${asset?.maxTradeAmount ?? 0}');

    //   if (category == PaymentMethodCategory.cards) {
    //     double? limitMax = max;

    //     if (limitByAsset != null) {
    //       limitMax = limitByAsset!.barInterval == StateBarType.day1
    //           ? (limitByAsset!.day1Limit - limitByAsset!.day1Amount).toDouble()
    //           : limitByAsset!.barInterval == StateBarType.day7
    //               ? (limitByAsset!.day7Limit - limitByAsset!.day7Amount).toDouble()
    //               : (limitByAsset!.day30Limit - limitByAsset!.day30Amount).toDouble();
    //     }

    //     max = limitMax < max ? limitMax : max;
    //   }

    //   inputValid = value >= min && value <= max;

    //   getIt.get<SimpleLoggerService>().log(
    //         level: Level.info,
    //         place: 'Buy Amount Store',
    //         message: 'min: $min, max: $max',
    //       );

    //   if (max == 0) {
    //     _updatePaymentMethodInputError(
    //       intl.limitIsExceeded,
    //     );
    //   } else if (value < min) {
    //     _updatePaymentMethodInputError(
    //       '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
    //         decimal: Decimal.parse(min.toString()),
    //         accuracy: buyCurrency.accuracy,
    //         symbol: buyCurrency.symbol,
    //       )}',
    //     );
    //   } else if (value > max) {
    //     _updatePaymentMethodInputError(
    //       '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
    //         decimal: Decimal.parse(max.toString()),
    //         accuracy: buyCurrency.accuracy,
    //         symbol: buyCurrency.symbol,
    //       )}',
    //     );
    //   } else {
    //     _updatePaymentMethodInputError(null);
    //   }
    // }

    // const error = InputError.none;

    // inputError = double.parse(inputValue) != 0
    //     ? error == InputError.none
    //         ? paymentMethodInputError == null
    //             ? InputError.none
    //             : InputError.limitError
    //         : error
    //     : InputError.none;
  }
}
