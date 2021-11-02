import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';
import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_preset.dart';
import 'components/numeric_keyboard_row.dart';
import 'constants.dart';

enum KeyboardPreset { preset1, preset2, preset3 }

class SNumericKeyboardAmount extends StatelessWidget {
  const SNumericKeyboardAmount({
    required this.preset1Name,
    required this.preset2Name,
    required this.preset3Name,
    required this.selectedPreset,
    required this.onPresetChanged,
    required this.onKeyPressed,
    required this.submitButtonActive,
    required this.submitButtonName,
    required this.onSubmitPressed,
  });

  final String preset1Name;
  final String preset2Name;
  final String preset3Name;
  final KeyboardPreset? selectedPreset;
  final void Function(KeyboardPreset) onPresetChanged;
  final void Function(String) onKeyPressed;
  final bool submitButtonActive;
  final String submitButtonName;
  final void Function() onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 422.h,
      child: Material(
        color: SColorsLight().grey5,
        child: Column(
          children: [
            const SpaceH20(),
            SPaddingH24(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NumericKeyboardPreset(
                    name: preset1Name,
                    selected: selectedPreset == KeyboardPreset.preset1,
                    onTap: () => onPresetChanged(KeyboardPreset.preset1),
                  ),
                  NumericKeyboardPreset(
                    name: preset2Name,
                    selected: selectedPreset == KeyboardPreset.preset2,
                    onTap: () => onPresetChanged(KeyboardPreset.preset2),
                  ),
                  NumericKeyboardPreset(
                    name: preset3Name,
                    selected: selectedPreset == KeyboardPreset.preset3,
                    onTap: () => onPresetChanged(KeyboardPreset.preset3),
                  ),
                ],
              ),
            ),
            NumericKeyboardFrame(
              height: 274.h,
              paddingTop: 10.h,
              paddingBottom: 10.h,
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
              child: SPrimaryButton1(
                active: submitButtonActive,
                name: submitButtonName,
                onTap: onSubmitPressed,
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
