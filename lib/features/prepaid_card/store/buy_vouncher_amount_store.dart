import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/account/phone_number/simple_number.dart';
import 'package:simple_kit/modules/keyboards/constants.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';

part 'buy_vouncher_amount_store.g.dart';

class BuyVouncherAmountAtore extends _BuyVouncherAmountAtoreBase with _$BuyVouncherAmountAtore {
  BuyVouncherAmountAtore({
    required super.brand,
    required super.country,
  }) : super();

  static BuyVouncherAmountAtore of(BuildContext context) => Provider.of<BuyVouncherAmountAtore>(context, listen: false);
}

abstract class _BuyVouncherAmountAtoreBase with Store {
  _BuyVouncherAmountAtoreBase({
    required this.brand,
    required this.country,
  }) {
    loadConversionPrice(
      cryptoSymbol,
      fiatSymbol,
    );
  }

  final PurchaseCardBrandDtoModel brand;
  final SPhoneNumber country;

  @computed
  CurrencyModel get currency => getIt.get<FormatService>().findCurrency(
        assetSymbol: 'USDT',
      );

  @computed
  CurrencyModel get brandCurrency => getIt.get<FormatService>().findCurrency(
        assetSymbol: brand.currency,
        findInHideTerminalList: true,
      );

  @observable
  Decimal targetConversionPrice = Decimal.one;

  @computed
  bool get isContinueAvaible {
    return inputValid && Decimal.parse(cryptoInputValue) != Decimal.zero && maxLimit != Decimal.zero;
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
    return brandCurrency.symbol;
  }

  @computed
  Decimal get minLimit {
    return brand.valueRestrictions?.minVal ?? Decimal.zero;
  }

  @computed
  Decimal get maxLimit {
    final assetBalance = getIt.get<FormatService>().convertOneCurrencyToAnotherOne(
          fromCurrency: currency.symbol,
          fromCurrencyAmmount: currency.assetBalance,
          toCurrency: brandCurrency.symbol,
          baseCurrency: sSignalRModules.baseCurrency.symbol,
          isMin: true,
        );
    final brandMaxLimit = brand.valueRestrictions?.maxVal ?? Decimal.parse(double.maxFinite.toString());

    return assetBalance < brandMaxLimit ? assetBalance : brandMaxLimit;
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
  Decimal get buyAllValue {
    return maxLimit;
  }

  @action
  void onBuyAll() {
    fiatInputValue = responseOnInputAction(
      oldInput: cryptoInputValue,
      newInput: buyAllValue.toString(),
      accuracy: currency.accuracy,
    );

    _calculateCryptoConversion();

    _validateInput();
  }

  @action
  void updateInputValue(String value) {
    fiatInputValue = responseOnInputAction(
      oldInput: fiatInputValue,
      newInput: value,
      accuracy: brandCurrency.accuracy,
    );

    _calculateCryptoConversion();

    _validateInput();
  }

  @action
  void pasteValue(String value) {
    fiatInputValue = value;

    _calculateCryptoConversion();

    _validateInput();
  }

  void _calculateCryptoConversion() {
    if (fiatInputValue != '0') {
      final amount = Decimal.parse(fiatInputValue);
      final price = targetConversionPrice;
      final accuracy = currency.accuracy;

      var conversion = Decimal.zero;

      if (price != Decimal.zero) {
        final koef = amount.toDouble() / price.toDouble();
        conversion = Decimal.parse(
          koef.toStringAsFixed(accuracy),
        );
      }

      cryptoInputValue = truncateZerosFrom(
        conversion.toString(),
      );
    } else {
      cryptoInputValue = zero;
    }
  }

  @action
  void _validateInput() {
    if (Decimal.parse(fiatInputValue) == Decimal.zero) {
      inputValid = true;
      inputError = InputError.none;
      _updatePaymentMethodInputError(null);

      return;
    }

    if (!isInputValid(fiatInputValue)) {
      inputValid = false;

      return;
    }

    final value = Decimal.parse(fiatInputValue);

    inputValid = value >= minLimit && value <= maxLimit;

    if (value < minLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: minLimit,
          accuracy: brandCurrency.accuracy,
          symbol: fiatSymbol,
        )}',
      );
    } else if (value > maxLimit) {
      _updatePaymentMethodInputError(
        '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: maxLimit,
          accuracy: brandCurrency.accuracy,
          symbol: fiatSymbol,
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
