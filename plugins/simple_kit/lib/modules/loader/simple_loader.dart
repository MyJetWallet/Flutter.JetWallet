import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';

class SimpleLoader extends StatelessWidget {
  const SimpleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: colors.grey1,
      ),
    );
  }
}
