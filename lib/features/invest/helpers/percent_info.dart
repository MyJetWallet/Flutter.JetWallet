import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

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
