import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
    return '${percent.toFormatSum(accuracy: 2).replaceAll(' ', '')}%';
  } else {
    return '+${percent.toFormatSum(accuracy: 2).replaceAll(' ', '')}%';
  }
}
