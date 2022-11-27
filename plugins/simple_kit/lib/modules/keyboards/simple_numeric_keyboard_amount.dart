import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';
import 'components/numeric_keyboard_frame.dart';
import 'components/numeric_keyboard_preset.dart';
import 'components/numeric_keyboard_row.dart';

enum SKeyboardPreset { preset1, preset2, preset3 }

class SNumericKeyboardAmount extends StatelessWidget {
  const SNumericKeyboardAmount({
    Key? key,
    this.buttonType = SButtonType.primary1,
    required this.widgetSize,
    required this.preset1Name,
    required this.preset2Name,
    required this.preset3Name,
    required this.selectedPreset,
    required this.onPresetChanged,
    required this.onKeyPressed,
    required this.submitButtonActive,
    required this.submitButtonName,
    required this.onSubmitPressed,
  }) : super(key: key);

  final SButtonType buttonType;
  final SWidgetSize widgetSize;
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
      height: widgetSize == SWidgetSize.medium ? 422 : 322,
      child: Material(
        color: SColorsLight().grey5,
        child: Column(
          children: [
            if (widgetSize == SWidgetSize.medium) ...[
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
            ],
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
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
