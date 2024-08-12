import 'package:jetwallet/features/currency_buy/models/formatted_circle_card.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

FormattedCircleCard formattedCircleCard(
  CircleCard card,
  BaseCurrencyModel base,
) {
  final formattedMin = card.paymentDetails.minAmount.toFormatCount(
    accuracy: base.accuracy,
    symbol: base.symbol,
  );
  final formattedMax = card.paymentDetails.maxAmount.toFormatCount(
    accuracy: base.accuracy,
    symbol: base.symbol,
  );
  final month = '${card.expMonth}';
  final formattedMonth = month.length == 1 ? '0$month' : month;
  final formattedYear = card.expYear.toString().substring(2);

  return FormattedCircleCard(
    name: card.network.name,
    last4Digits: '•••• ${card.last4}',
    expDate: 'Exp. $formattedMonth / $formattedYear',
    limit: 'Lim: $formattedMin / $formattedMax',
  );
}
