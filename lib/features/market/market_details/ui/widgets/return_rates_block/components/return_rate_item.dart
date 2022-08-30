import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ReturnRateItem extends StatelessWidget {
  const ReturnRateItem({
    Key? key,
    required this.header,
    required this.value,
  }) : super(key: key);

  final String header;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final periodChangeColor = value.contains('-') ? colors.red : colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SBaselineChild(
          baseline: 44,
          child: Text(
            header,
            style: sBodyText2Style.copyWith(
              color: colors.grey1,
            ),
          ),
        ),
        SBaselineChild(
          baseline: 24,
          child: Text(
            value,
            style: sBodyText1Style.copyWith(
              color: periodChangeColor,
            ),
          ),
        ),
      ],
    );
  }
}
