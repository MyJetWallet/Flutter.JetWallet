import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/keyboards/constants.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

part 'earn_withdrawal_amount_store.g.dart';

class EarnWithdrawalAmountStore extends _EarnWithdrawalAmountStoreBase with _$EarnWithdrawalAmountStore {
  EarnWithdrawalAmountStore({required super.earnPosition}) : super();

  static EarnWithdrawalAmountStore of(BuildContext context) =>
      Provider.of<EarnWithdrawalAmountStore>(context, listen: false);
}

abstract class _EarnWithdrawalAmountStoreBase with Store {
  _EarnWithdrawalAmountStoreBase({required this.earnPosition}) {
    sAnalytics.earnWithdrawAmountScreenView(
      assetName: earnPosition.assetId,
      earnOfferId: earnPosition.offerId,
      earnPlanName: earnPosition.offers.first.name ?? '',
      earnWithdrawalType: earnPosition.withdrawType.name,
      fullWithdrawType: earnPosition.offers.first.withdrawType == WithdrawType.lock,
    );
    loadConversionPrice(
      fiatSymbol,
      cryptoSymbol,
    );
  }

  final EarnPositionClientModel earnPosition;

  @computed
  CurrencyModel get currency => getIt.get<FormatService>().findCurrency(
        assetSymbol: earnPosition.assetId,
      );

  @computed
  CurrencyModel get eurCurrency => getIt.get<FormatService>().findCurrency(
        assetSymbol: fiatSymbol,
        findInHideTerminalList: true,
      );

  @observable
  Decimal targetConversionPrice = Decimal.one;

  @computed
  bool get isContinueAvaible {
    return inputValid && Decimal.parse(cryptoInputValue) != Decimal.zero;
  }

  @observable
  InputError inputError = InputError.none;

  @observable
  String? errorText;

  @observable
  bool inputValid = false;

  @observable
  String fiatInputValue = '0';

  @observable
  String cryptoInputValue = '0';

  @computed
  String get cryptoSymbol => currency.symbol;

  @computed
  String get fiatSymbol {
    return sSignalRModules.baseCurrency.symbol;
  }

  @computed
  Decimal get minLimit {
    return Decimal.zero;
  }

  @computed
  Decimal get maxLimit {
    return earnPosition.baseAmount - (earnPosition.offers.first.minAmount ?? Decimal.zero);
  }

  @action
  Future<void> loadConversionPrice(
    String baseS,
    String targetS,
  ) async {
    final result = await getConversionPrice(
      ConversionPriceInput(
        baseAssetSymbol: baseS,
        quotedAssetSymbol: targetS,
      ),
    );
    targetConversionPrice = result ?? Decimal.one;
  }

  @computed
  Decimal get withdrawAllValue {
    return maxLimit;
  }

  @action
  void onSellAll() {
    cryptoInputValue = '0';
    cryptoInputValue = responseOnInputAction(
      oldInput: cryptoInputValue,
      newInput: withdrawAllValue.toString(),
      accuracy: currency.accuracy,
    );

    _calculateFiatConversion();

    _validateInput();
  }

  @action
  void updateInputValue(String value) {
    cryptoInputValue = responseOnInputAction(
      oldInput: cryptoInputValue,
      newInput: value,
      accuracy: currency.accuracy,
    );

    _calculateFiatConversion();

    _validateInput();
  }

  @action
  void pasteValue(String value) {
    cryptoInputValue = value;

    _calculateFiatConversion();

    _validateInput();
  }

  void _calculateFiatConversion() {
    if (cryptoInputValue != '0') {
      final amount = Decimal.parse(cryptoInputValue);
      final price = targetConversionPrice;
      final accuracy = currency.accuracy;

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
    if (Decimal.parse(cryptoInputValue) == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(cryptoInputValue)) {
      inputValid = false;

      return;
    }

    if (maxLimit == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    final value = Decimal.parse(cryptoInputValue);

    inputValid = value >= minLimit && value <= maxLimit;

    if (maxLimit == Decimal.zero) {
      _updatePaymentMethodInputError(
        null,
      );
    } else if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${minLimit.toFormatCount(
          accuracy: currency.accuracy,
          symbol: cryptoSymbol,
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${maxLimit.toFormatCount(
          accuracy: currency.accuracy,
          symbol: cryptoSymbol,
        )}',
      );
    } else {
      _updatePaymentMethodInputError(null);
    }
  }

  @action
  void _updatePaymentMethodInputError(String? error) {
    errorText = error;
  }
}
