import 'package:flutter/material.dart';

import 'components/keyboard_row.dart';
import 'components/number_keyboard_frame.dart';
import 'key_constants.dart';

class NumberKeyboardAmount extends StatelessWidget {
  const NumberKeyboardAmount({
    required this.onKeyPressed,
  });

  final void Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return NumberKeyboardFrame(
      lastRow: KeyboardRow(
        frontKey1: ',',
        realValue1: period,
        frontKey2: zero,
        realValue2: zero,
        frontKey3: backspace,
        realValue3: backspace,
        onKeyPressed: onKeyPressed,
      ),
      onKeyPressed: onKeyPressed,
    );
  }
}
