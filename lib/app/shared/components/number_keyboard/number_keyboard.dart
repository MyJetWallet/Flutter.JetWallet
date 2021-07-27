import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/keyboard_row.dart';

const backspace = '«';

class NumberKeyboard extends StatelessWidget {
  const NumberKeyboard({
    required this.onKeyPressed,
  });

  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.3.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KeyboardRow(
            frontKey1: '1',
            frontKey2: '2',
            frontKey3: '3',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            frontKey1: '4',
            frontKey2: '5',
            frontKey3: '6',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            frontKey1: '7',
            frontKey2: '8',
            frontKey3: '9',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            realKey1: '.',
            frontKey1: ',',
            frontKey2: '0',
            frontKey3: backspace,
            onKeyPressed: onKeyPressed,
          ),
        ],
      ),
    );
  }
}
