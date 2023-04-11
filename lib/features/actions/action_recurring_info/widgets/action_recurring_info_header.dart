import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionRecurringInfoHeader extends StatelessObserverWidget {
  const ActionRecurringInfoHeader({
    required this.total,
    required this.amount,
  });

  final String total;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SpaceH34(),
          Text(
            total,
            style: sTextH1Style,
            textAlign: TextAlign.center,
          ),
          Text(
            amount,
            style: sBodyText2Style.copyWith(
              color: colors.grey1,
            ),
            textAlign: TextAlign.center,
          ),
          const SpaceH34(),
        ],
      ),
    );
  }
}
