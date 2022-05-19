import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionRecurringInfoHeader extends HookWidget {
  const ActionRecurringInfoHeader({
    Key? key,
    required this.total,
    required this.amount,
  }) : super(key: key);

  final String total;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

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
