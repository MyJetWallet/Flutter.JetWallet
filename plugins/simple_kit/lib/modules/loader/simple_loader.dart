import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';

@Deprecated('This is a widget from the old ui kit, please use the widget from the new ui kit')
class SimpleLoader extends StatelessWidget {
  const SimpleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: colors.grey1,
      ),
    );
  }
}
