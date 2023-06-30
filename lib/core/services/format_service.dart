import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import 'signal_r/signal_r_service_new.dart';

part 'format_service.g.dart';

class FormatService = _FormatServiceBase with _$FormatService;

abstract class _FormatServiceBase with Store {
  _FormatServiceBase();

  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  String convertHistoryToBaseCurrency(
    OperationHistoryItem transactionListItem,
    Decimal operationAmount,
    String operationAsset,
  ) {
    final priceInUSD = transactionListItem.assetPriceInUsd * operationAmount;
    final usdCurrencyAsset = findCurrency(
      assetSymbol: 'USD',
      findInHideTerminalList: true,
    );
    final priceInBaseCurrency = usdCurrencyAsset.currentPrice * priceInUSD;

    if (operationAsset == baseCurrency.symbol) {
      return '≈ ${baseCurrenciesFormat(
        text: operationAmount.toStringAsFixed(2),
        symbol: baseCurrency.symbol,
        prefix: baseCurrency.prefix,
      )}';
    } else {
      return '≈ ${baseCurrenciesFormat(
        text: priceInBaseCurrency.toStringAsFixed(2),
        symbol: baseCurrency.symbol,
        prefix: baseCurrency.prefix,
      )}';
    }
  }

  CurrencyModel findCurrency({
    required String assetSymbol,
    bool findInHideTerminalList = false,
  }) {
    return findInHideTerminalList
        ? sSignalRModules.currenciesWithHiddenList.firstWhere(
            (currency) => currency.symbol == assetSymbol,
            orElse: () => CurrencyModel.empty(),
          )
        : sSignalRModules.currenciesList.firstWhere(
            (currency) => currency.symbol == assetSymbol,
            orElse: () => CurrencyModel.empty(),
          );
  }

  // This function convert One currency to Another One. FromCurrency -> Base Currency -> Converted (ToCurrency)
  Decimal convertOneCurrencyToAnotherOne({
    required String fromCurrency,
    required Decimal fromCurrencyAmmount,
    required String toCurrency,
    required String baseCurrency,
    required bool goingUp,
  }) {
    final fromAsset = findCurrency(
      assetSymbol: fromCurrency,
      findInHideTerminalList: true,
    );
    final toAsset = findCurrency(
      assetSymbol: toCurrency,
      findInHideTerminalList: true,
    );
    final baseAsset = findCurrency(
      assetSymbol: baseCurrency,
      findInHideTerminalList: true,
    );

    // Covnert FromCurrency to User base currency
    final fromCurrInBaseCurr = fromCurrencyAmmount * fromAsset.currentPrice;

    final baseCurrencyToAsset =
        baseAsset.currentPrice.toDouble() / toAsset.currentPrice.toDouble();

    final toAmmount = fromCurrInBaseCurr.toDouble() * baseCurrencyToAsset;
    Decimal finalAmmount = Decimal.parse(toAmmount.toString());

    double smartRound(double number, int normalizedAccuracy) {
      double roundToInfinity(double value, int decimalPlaces) {
        num decimalMultiplier = pow(10, decimalPlaces.abs()).toDouble();

        return !goingUp
            ? (value * decimalMultiplier).ceilToDouble() / decimalMultiplier
            : (value * decimalMultiplier).roundToDouble() / decimalMultiplier;
        //: (value * decimalMultiplier).floorToDouble() / decimalMultiplier;
      }

      double roundWithAccuracy(double number, int normalizedAccuracy) {
        double roundingFactor = pow(10, normalizedAccuracy.abs()).toDouble();

        return goingUp
            ? (number / roundingFactor).ceilToDouble() * roundingFactor
            : (number / roundingFactor).floorToDouble() * roundingFactor;
      }

      if (normalizedAccuracy > 0) {
        return roundToInfinity(number, normalizedAccuracy);
      } else if (normalizedAccuracy < 0) {
        return roundWithAccuracy(number, normalizedAccuracy);
      }

      return number;
    }

    print("toAmmount: ${toAmmount}");
    print("normalizedAccuracy: ${toAsset.normalizedAccuracy}");
    print(Decimal.parse('${smartRound(
      finalAmmount.toDouble(),
      toAsset.normalizedAccuracy,
    )}'));

    return Decimal.parse('${smartRound(
      finalAmmount.toDouble(),
      toAsset.normalizedAccuracy,
    )}');
  }
}
