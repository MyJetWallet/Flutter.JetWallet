import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/keyboards/components/numeric_keyboard_row.dart';

class NumericKeyboardFrame extends StatelessWidget {
  const NumericKeyboardFrame({
    Key? key,
    this.paddingBottom,
    required this.heightBetweenRows,
    required this.paddingTop,
    required this.height,
    required this.lastRow,
    required this.onKeyPressed,
  }) : super(key: key);

  final double heightBetweenRows;
  final double? paddingBottom;
  final double paddingTop;
  final double height;
  final NumericKeyboardRow lastRow;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: SColorsLight().white,
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: paddingTop,
        bottom: paddingBottom ?? 0,
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
          SizedBox(
            height: heightBetweenRows,
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
          SizedBox(
            height: heightBetweenRows,
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
          SizedBox(
            height: heightBetweenRows,
          ),
          lastRow,
        ],
      ),
    );
  }
}
