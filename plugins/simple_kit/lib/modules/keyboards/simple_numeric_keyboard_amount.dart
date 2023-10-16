import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';
import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_row.dart';

class SNumericKeyboardAmount extends StatelessWidget {
  const SNumericKeyboardAmount({
    Key? key,
    this.buttonType = SButtonType.primary1,
    required this.widgetSize,
    required this.onKeyPressed,
    required this.submitButtonActive,
    required this.submitButtonName,
    required this.onSubmitPressed,
  }) : super(key: key);

  final SButtonType buttonType;
  final SWidgetSize widgetSize;
  final void Function(String) onKeyPressed;
  final bool submitButtonActive;
  final String submitButtonName;
  final void Function() onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widgetSize == SWidgetSize.medium ? 380 : 340,
      child: Material(
        color: SColorsLight().white,
        child: Column(
          children: [
            NumericKeyboardFrame(
              heightBetweenRows: widgetSize == SWidgetSize.medium ? 10 : 2,
              height: widgetSize == SWidgetSize.medium ? 274 : 242,
              paddingTop: widgetSize == SWidgetSize.medium ? 10 : 5,
              paddingBottom: widgetSize == SWidgetSize.medium ? 10 : 6,
              lastRow: NumericKeyboardRow(
                frontKey1: period,
                realValue1: period,
                frontKey2: zero,
                realValue2: zero,
                icon3: const SNumericKeyboardEraseIcon(),
                iconPressed3: const SNumericKeyboardErasePressedIcon(),
                realValue3: backspace,
                onKeyPressed: onKeyPressed,
              ),
              onKeyPressed: onKeyPressed,
            ),
            SPaddingH24(
              child: buttonType == SButtonType.primary1
                  ? SPrimaryButton1(
                      active: submitButtonActive,
                      name: submitButtonName,
                      onTap: onSubmitPressed,
                    )
                  : SPrimaryButton2(
                      active: submitButtonActive,
                      name: submitButtonName,
                      onTap: onSubmitPressed,
                    ),
            ),
            const SpaceH42(),
          ],
        ),
      ),
    );
  }
}
