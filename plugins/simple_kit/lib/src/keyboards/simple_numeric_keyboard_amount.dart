import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_preset.dart';
import 'components/numeric_keyboard_row.dart';

enum SKeyboardPreset { preset1, preset2, preset3 }

enum SButtonType { primary1, primary2 }

class SNumericKeyboardAmount extends StatelessWidget {
  const SNumericKeyboardAmount({
    this.buttonType = SButtonType.primary1,
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

  final SButtonType buttonType;
  final String preset1Name;
  final String preset2Name;
  final String preset3Name;
  final SKeyboardPreset? selectedPreset;
  final void Function(SKeyboardPreset) onPresetChanged;
  final void Function(String) onKeyPressed;
  final bool submitButtonActive;
  final String submitButtonName;
  final void Function() onSubmitPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 422.0,
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
                    selected: selectedPreset == SKeyboardPreset.preset1,
                    onTap: () => onPresetChanged(SKeyboardPreset.preset1),
                  ),
                  const SpaceW10(),
                  NumericKeyboardPreset(
                    name: preset2Name,
                    selected: selectedPreset == SKeyboardPreset.preset2,
                    onTap: () => onPresetChanged(SKeyboardPreset.preset2),
                  ),
                  const SpaceW10(),
                  NumericKeyboardPreset(
                    name: preset3Name,
                    selected: selectedPreset == SKeyboardPreset.preset3,
                    onTap: () => onPresetChanged(SKeyboardPreset.preset3),
                  ),
                ],
              ),
            ),
            NumericKeyboardFrame(
              height: 274.0,
              paddingTop: 10.0,
              paddingBottom: 10.0,
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
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
