import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'keyboard_row.dart';

class NumberKeyboardFrame extends StatelessWidget {
  const NumberKeyboardFrame({
    Key? key,
    required this.lastRow,
    required this.onKeyPressed,
  }) : super(key: key);

  final KeyboardRow lastRow;
  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.32.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KeyboardRow(
            frontKey1: '1',
            realValue1: '1',
            frontKey2: '2',
            realValue2: '2',
            frontKey3: '3',
            realValue3: '3',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            frontKey1: '4',
            realValue1: '4',
            frontKey2: '5',
            realValue2: '5',
            frontKey3: '6',
            realValue3: '6',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
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
