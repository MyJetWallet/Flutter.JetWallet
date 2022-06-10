import 'package:simple_networking/services/circle/model/circle_card.dart';

import '../../../helpers/formatting/base/volume_format.dart';
import '../../../providers/base_currency_pod/base_currency_model.dart';
import '../model/formatted_circle_card.dart';

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
    name: card.network,
    last4Digits: '•••• ${card.last4}',
    expDate: 'Exp. $formattedMonth / $formattedYear',
    limit: 'Lim: $formattedMin / $formattedMax',
  );
}
