import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
        SSkeletonTextLoader(
          height: 10,
          width: 26,
        ),
        SizedBox(
          height: 10,
        ),
        SSkeletonTextLoader(
          height: 16,
          width: 52,
        ),
      ],
    );
  }
}
