import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomTab extends StatelessWidget {
  const BottomTab({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      margin: const EdgeInsets.only(
        right: 10,
        top: 1,
      ),
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 7,
        right: 15,
        left: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        border: Border.all(
          color: colors.grey2.withOpacity(0.4),
        ),
      ),
      child: Text(text),
    );
  }
}
