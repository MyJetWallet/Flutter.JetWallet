import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SimpleLoader extends StatelessWidget {
  const SimpleLoader({
    super.key,
    this.size = 20,
    this.strokeWidth = 2,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      width: size - 4,
      height: size - 4,
      margin: EdgeInsets.all(2),
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? colors.gray10,
      ),
    );
  }
}
