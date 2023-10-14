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
    if (category == PaymentMethodCategory.account) {
      if (account!.balance! < Decimal.parse(fiatInputValue)) {
        errorText = 'Not enough balance to proceed with the transaction';
        inputValid = false;

        return;
      }
    } else if (category == PaymentMethodCategory.cards) {
      if (card!.paymentDetails.minAmount > Decimal.parse(fiatInputValue)) {
        errorText = 'min: ${card!.paymentDetails.minAmount}';
        inputValid = false;

        return;
      } else if (card!.paymentDetails.maxAmount < Decimal.parse(fiatInputValue)) {
        errorText = 'max: ${card!.paymentDetails.maxAmount}';
        inputValid = false;

        return;
      }
    }
    inputValid = Decimal.parse(fiatInputValue) != Decimal.zero;
    errorText = null;
  }
}
