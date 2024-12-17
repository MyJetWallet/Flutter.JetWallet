import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class ReturnRateItem extends StatelessWidget {
  const ReturnRateItem({
    super.key,
    required this.header,
    required this.value,
  });

  final String header;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final periodChangeColor = value.contains('-') ? colors.red : colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          header,
          style: STStyles.body2Medium,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: STStyles.subtitle1.copyWith(
            color: periodChangeColor,
          ),
        ),
      ],
    );
  }
}

class ReturnRateItemSketelon extends StatelessWidget {
  const ReturnRateItemSketelon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SSkeletonLoader(
          height: 10,
          width: 26,
        ),
        SizedBox(
          height: 10,
        ),
        SSkeletonLoader(
          height: 16,
          width: 52,
        ),
      ],
    );
  }
}
