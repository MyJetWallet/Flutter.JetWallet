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
      return '≈ ${volumeFormat(
        prefix: baseCurrency.prefix,
        decimal: operationAmount,
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
      )}';
    } else {
      return '≈ ${volumeFormat(
        prefix: baseCurrency.prefix,
        decimal: priceInBaseCurrency,
        accuracy: baseCurrency.accuracy,
        symbol: baseCurrency.symbol,
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
    required bool isMin,
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

    return finalAmmount;

    double smartRound(double number, int normalizedAccuracy) {
      double roundWithAccuracy(double number, int normalizedAccuracy) {
        final res = isMin
            ? number.ceilDigits(normalizedAccuracy)
            : number.floorDigits(normalizedAccuracy);

        return isMin
            ? number >= res
                ? number
                : res
            : number <= res
                ? number
                : res;
      }

      return normalizedAccuracy == 0
          ? number
          : roundWithAccuracy(number, normalizedAccuracy);
    }

    return Decimal.parse(
      '${smartRound(
        finalAmmount.toDouble(),
        toAsset.normalizedAccuracy,
      )}',
    );
  }

  Decimal smartRound({
    required Decimal number,
    required String toCurrency,
    required bool isMin,
  }) {
    final toAsset = findCurrency(
      assetSymbol: toCurrency,
      findInHideTerminalList: true,
    );

    double roundWithAccuracy(double number, int normalizedAccuracy) {
      final res = isMin
          ? number.ceilDigits(normalizedAccuracy)
          : number.floorDigits(normalizedAccuracy);

      return isMin
          ? number >= res
              ? number
              : res
          : number <= res
              ? number
              : res;
    }

    return toAsset.normalizedAccuracy == 0
        ? number
        : Decimal.parse(
            '${roundWithAccuracy(number.toDouble(), toAsset.normalizedAccuracy)}',
          );
  }
}

extension DoubleRounding on double {
  /// Floors to given number of digits
  ///
  /// 10.2468.floorDigits(1) -> 10.2
  /// 10.2468.floorDigits(2) -> 10.24
  /// 10.2468.floorDigits(3) -> 10.246
  ///
  /// Might give unexpected results due to precision loss: 10.2.floorDigits(5) -> 10.199999999999999
  double floorDigits(int digits) {
    if (digits == 0) {
      return this.floorToDouble();
    } else {
      final divideBy = pow(10, digits);
      return ((this * divideBy).floorToDouble() / divideBy);
    }
  }

  double ceilDigits(int digits) {
    if (digits == 0) {
      return this.ceilToDouble();
    } else {
      final divideBy = pow(10, digits);
      return ((this * divideBy).ceilToDouble() / divideBy);
    }
  }
}
