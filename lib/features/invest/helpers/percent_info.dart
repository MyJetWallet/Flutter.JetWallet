import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_profit_equal.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_profit_loss.dart';
import 'package:simple_kit/modules/icons/custom/public/invest/simple_invest_profit_win.dart';

import '../../../utils/formatting/base/market_format.dart';

Widget percentIcon(Decimal percent) {
  return percent == Decimal.zero
      ? const SIProfitEqualIcon(width: 12, height: 12,)
      : percent < Decimal.zero
      ? const SIProfitLossIcon(width: 12, height: 12,)
      : const SIProfitWinIcon(width: 12, height: 12,);
}

String formatPercent(Decimal percent) {
  if (percent == Decimal.zero) {
    return '0.00%';
  } else if (percent < Decimal.zero) {
    return '${marketFormat(decimal: percent, accuracy: 2, symbol: '').replaceAll(' ', '')}%';
  } else {
    return '+${marketFormat(decimal: percent, accuracy: 2, symbol: '').replaceAll(' ', '')}%';
  }
}