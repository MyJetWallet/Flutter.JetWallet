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

    print('toAmmount: ${finalAmmount}');

    print('normalizedAccuracy: ${fromAsset.normalizedAccuracy}');

    if (fromAsset.normalizedAccuracy > 0) {
      finalAmmount = finalAmmount.ceil();
    } else {
      var n = pow(10, fromAsset.normalizedAccuracy.abs());
      n = n.round();
      finalAmmount = finalAmmount *
          Decimal.parse(fromAsset.normalizedAccuracy.abs().toString());
    }

    print('finalAmmount: ${finalAmmount}');

    return finalAmmount;
  }
}
