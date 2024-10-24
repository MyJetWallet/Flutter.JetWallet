import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/keyboard/components/numeric_keyboard_row.dart';

class NumericKeyboardFrame extends StatelessWidget {
  const NumericKeyboardFrame({
    super.key,
    required this.lastRow,
    required this.onKeyPressed,
  });

  final NumericKeyboardRow lastRow;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColorsLight().white,
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 16,
        bottom: 20,
      ),
      child: Column(
        children: [
          NumericKeyboardRow(
            frontKey1: '1',
            realValue1: '1',
            frontKey2: '2',
            realValue2: '2',
            frontKey3: '3',
            realValue3: '3',
            onKeyPressed: onKeyPressed,
          ),
          NumericKeyboardRow(
            frontKey1: '4',
            realValue1: '4',
            frontKey2: '5',
            realValue2: '5',
            frontKey3: '6',
            realValue3: '6',
            onKeyPressed: onKeyPressed,
          ),
          NumericKeyboardRow(
            frontKey1: '7',
            realValue1: '7',
            frontKey2: '8',
            realValue2: '8',
            frontKey3: '9',
            realValue3: '9',
            onKeyPressed: onKeyPressed,
          ),
          lastRow,
        ],
      ),
    );
  }
}
