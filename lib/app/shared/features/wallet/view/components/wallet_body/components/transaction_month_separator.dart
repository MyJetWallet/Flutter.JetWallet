import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class TransactionMonthSeparator extends HookWidget {
  const TransactionMonthSeparator({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SizedBox(
      height: 21,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 24,
            ),
            child: Baseline(
              baseline: 11,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                text,
                style: sCaptionTextStyle.copyWith(color: colors.grey3),
              ),
            ),
          ),
          const SpaceW10(),
          Expanded(
            child: SDivider(
              color: colors.grey3,
            ),
          ),
        ],
      ),
    );
  }
}
