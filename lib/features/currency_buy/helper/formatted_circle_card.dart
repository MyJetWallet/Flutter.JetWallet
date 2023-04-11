import 'package:jetwallet/features/currency_buy/models/formatted_circle_card.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

FormattedCircleCard formattedCircleCard(
  CircleCard card,
  BaseCurrencyModel base,
) {
  final formattedMin = volumeFormat(
    accuracy: base.accuracy,
    prefix: base.prefix,
    symbol: base.symbol,
    decimal: card.paymentDetails.minAmount,
  );
  final formattedMax = volumeFormat(
    accuracy: base.accuracy,
    prefix: base.prefix,
    symbol: base.symbol,
    decimal: card.paymentDetails.maxAmount,
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
