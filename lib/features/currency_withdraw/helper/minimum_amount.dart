import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/models/currency_model.dart';

/// Used when [InputError.enterHigherAmount]
String minimumAmount(CurrencyModel currency) {
  return currency.isFeeInOtherCurrency
      ? intl.minimumAmount_noMinimum
      : '${intl.min1} ${currency.withdrawalFeeSize} ${currency.symbol}';
}
