import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/keyboard_row.dart';

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
            key1: '1',
            key2: '2',
            key3: '3',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            key1: '4',
            key2: '5',
            key3: '6',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            key1: '7',
            key2: '8',
            key3: '9',
            onKeyPressed: onKeyPressed,
          ),
          KeyboardRow(
            key1: ',',
            key2: '0',
            key3: '«',
            onKeyPressed: onKeyPressed,
          ),
        ],
      ),
    );
  }
}
