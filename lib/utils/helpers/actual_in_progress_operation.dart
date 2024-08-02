import 'package:decimal/decimal.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

// Checks for operation in progress name
String actualInProcessOperationName(
  CurrencyModel currency,
  String transferName,
  String earnName,
  String buyName,
) {
  if (currency.transfersInProcessTotal > Decimal.zero) {
    return transferName;
  } else if (currency.earnInProcessTotal > Decimal.zero) {
    return earnName;
  } else if (currency.buysInProcessTotal > Decimal.zero) {
    return buyName;
  }

  return '';
}

// Counter of transactions
int counterOfOperationInProgressTransactions(CurrencyModel currency) {
  return currency.transfersInProcessCount + currency.buysInProcessCount + currency.earnInProcessCount;
}
