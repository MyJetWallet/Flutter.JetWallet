import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TransactionMonthSeparator extends StatelessObserverWidget {
  const TransactionMonthSeparator({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      height: 21,
      child: Container(
        padding: const EdgeInsets.only(
          left: 24,
        ),
        child: Baseline(
          baseline: 11,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            localizedMonth(text, context),
            style: STStyles.body2Semibold.copyWith(
              color: colors.grey3,
            ),
          ),
        ),
      ),
    );
  }
}
