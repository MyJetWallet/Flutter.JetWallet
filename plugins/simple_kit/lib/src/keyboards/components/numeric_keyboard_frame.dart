import 'package:flutter/material.dart';

import '../../../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';
import 'numeric_keyboard_row.dart';

class NumericKeyboardFrame extends StatelessWidget {
  const NumericKeyboardFrame({
    Key? key,
    this.paddingBottom,
    this.isSmall = false,
    required this.paddingTop,
    required this.height,
    required this.lastRow,
    required this.onKeyPressed,
  }) : super(key: key);

  final double? paddingBottom;
  final double paddingTop;
  final double height;
  final NumericKeyboardRow lastRow;
  final void Function(String) onKeyPressed;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: SColorsLight().grey5,
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
          if (isSmall) const SpaceH2(),
          if (!isSmall) const SpaceH10(),
          NumericKeyboardRow(
            frontKey1: '4',
            realValue1: '4',
            frontKey2: '5',
            realValue2: '5',
            frontKey3: '6',
            realValue3: '6',
            onKeyPressed: onKeyPressed,
          ),
          if (isSmall) const SpaceH2(),
          if (!isSmall) const SpaceH10(),
          NumericKeyboardRow(
            frontKey1: '7',
            realValue1: '7',
            frontKey2: '8',
            realValue2: '8',
            frontKey3: '9',
            realValue3: '9',
            onKeyPressed: onKeyPressed,
          ),
          if (isSmall) const SpaceH3(),
          if (!isSmall) const SpaceH10(),
          lastRow,
        ],
      ),
    );
  }
}
