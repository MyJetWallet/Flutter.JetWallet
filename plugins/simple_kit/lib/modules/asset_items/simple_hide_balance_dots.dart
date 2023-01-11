import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleHideBalanceDots extends StatelessWidget {
  const SimpleHideBalanceDots({
    Key? key,
    this.margin = const EdgeInsets.symmetric(horizontal: 1.0),
    required this.color,
  }) : super(key: key);

  final Color color;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 4; i++)
          Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            margin: margin,
            child: const SizedBox.shrink(),
          ),
      ],
    );
  }
}
