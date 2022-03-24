import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../../../shared.dart';
import 'simple_numeric_keyboard_amount_guides.dart';

class SimpleNumericKeyboardAmountExample extends HookWidget {
  const SimpleNumericKeyboardAmountExample({Key? key}) : super(key: key);

  static const routeName = '/simple_numeric_keyboard_amount_example';

  @override
  Widget build(BuildContext context) {
    final selectedPreset = useState<SKeyboardPreset?>(null);
    final activeButton = useState(false);

    return SPageFrame(
      child: Column(
        children: [
          const Spacer(),
          const NavigationButton(
            buttonName: 'Guides',
            routeName: SimpleNumericKeyboardAmountGuides.routeName,
          ),
          TextButton(
            onPressed: () => activeButton.value = !activeButton.value,
            child: const Text(
              'Enable/Disable Button',
            ),
          ),
          const Spacer(),
          SNumericKeyboardAmount(
            keyboardSize: SKeyboardSize.medium,
            preset1Name: '\$50',
            preset2Name: '\$100',
            preset3Name: '\$500',
            selectedPreset: selectedPreset.value,
            onPresetChanged: (keyboardPreset) {
              selectedPreset.value = keyboardPreset;
            },
            onKeyPressed: (key) {
              showSnackBar(context, key);
            },
            submitButtonActive: activeButton.value,
            submitButtonName: 'Primary',
            onSubmitPressed: () {
              showSnackBar(context, 'Submit pressed');
            },
          )
        ],
      ),
    );
  }
}
