import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/formatting/base/market_format.dart';

Widget percentIcon(Decimal percent) {
  return percent == Decimal.zero
      ? Assets.svg.invest.profitEqual.simpleSvg(
          width: 12,
          height: 12,
        )
      : percent < Decimal.zero
          ? Assets.svg.invest.profitLoss.simpleSvg(
              width: 12,
              height: 12,
            )
          : Assets.svg.invest.profitWin.simpleSvg(
              width: 12,
              height: 12,
            );
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
