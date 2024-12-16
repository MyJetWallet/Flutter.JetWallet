import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../shared/simple_safe_button_padding.dart';
import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_row.dart';

enum NumericKeyboardType { touchId, fasceId, point, none }

class SNumericKeyboard extends StatelessWidget {
  const SNumericKeyboard({
    super.key,
    required this.onKeyPressed,
    this.button,
    this.type = NumericKeyboardType.point,
  });

  final void Function(String) onKeyPressed;
  final SButton? button;
  final NumericKeyboardType type;

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
                frontKey1: type == NumericKeyboardType.point ? period : null,
                realValue1: type == NumericKeyboardType.point
                    ? period
                    : type == NumericKeyboardType.fasceId
                        ? face
                        : type == NumericKeyboardType.touchId
                            ? fingerprint
                            : '',
                icon1: type == NumericKeyboardType.fasceId
                    ? Assets.svg.medium.faceId.simpleSvg()
                    : type == NumericKeyboardType.touchId
                        ? Assets.svg.medium.touchId.simpleSvg()
                        : const SizedBox(),
                iconPressed1: type == NumericKeyboardType.fasceId
                    ? Assets.svg.medium.faceId.simpleSvg()
                    : type == NumericKeyboardType.touchId
                        ? Assets.svg.medium.touchId.simpleSvg()
                        : const SizedBox(),
                frontKey2: zero,
                realValue2: zero,
                icon3: Assets.svg.medium.arrowLeft.simpleSvg(),
                iconPressed3: Assets.svg.medium.arrowLeft.simpleSvg(),
                realValue3: backspace,
                onKeyPressed: onKeyPressed,
              ),
              onKeyPressed: onKeyPressed,
            ),
            if (button != null)
              SSafeButtonPadding(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 8, // отступ кнопки (8)
                  ),
                  child: button,
                ),
              )
            else
              SizedBox(
                height: MediaQuery.of(context).padding.bottom <= 24 ? 16 : 0,
              )
          ],
        ),
      ),
    );
  }
}
