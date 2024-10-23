import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/keyboard/constants.dart';

import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_row.dart';

class SNumericKeyboard extends StatelessWidget {
  const SNumericKeyboard({
    super.key,
    required this.onKeyPressed,
    this.button,
  });

  final void Function(String) onKeyPressed;
  final SButton? button;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        color: SColorsLight().white,
        child: Column(
          children: [
            NumericKeyboardFrame(
              lastRow: NumericKeyboardRow(
                frontKey1: period,
                realValue1: period,
                frontKey2: zero,
                realValue2: zero,
                icon3: Center(
                  child: Assets.svg.medium.arrowLeft.simpleSvg(
                    width: 24,
                    height: 24,
                  ),
                ),
                iconPressed3: Center(
                  child: Assets.svg.medium.arrowLeft.simpleSvg(
                    width: 24,
                    height: 24,
                  ),
                ),
                realValue3: backspace,
                onKeyPressed: onKeyPressed,
              ),
              onKeyPressed: onKeyPressed,
            ),
            if (button != null)
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom <= 24 ? 24 : 8,
                ),
                child: button,
              ),
          ],
        ),
      ),
    );
  }
}
