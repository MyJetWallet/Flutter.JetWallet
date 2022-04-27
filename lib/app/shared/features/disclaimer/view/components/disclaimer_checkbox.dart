import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../notifier/disclaimer_notipod.dart';

class DisclaimerCheckbox extends HookWidget {
  const DisclaimerCheckbox({
    Key? key,
    this.indexCheckBox,
    required this.firstText,
    required this.onCheckboxTap,
  }) : super(key: key);

  final int? indexCheckBox;
  final String firstText;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    final state = useProvider(disclaimerNotipod);
    final colors = useProvider(sColorPod);

    if (indexCheckBox != null) {
      if (state.questions[indexCheckBox!].defaultState) {
        icon = const SCheckboxSelectedIcon();
      } else {
        icon = const SCheckboxIcon();
      }
    }

    return SizedBox(
      height: 44.0,
      child: Row(
        children: [
          Column(
            children: [
              //const SpaceH20(),
              SIconButton(
                onTap: onCheckboxTap,
                defaultIcon: icon,
                pressedIcon: icon,
              ),
            ],
          ),
          const SpaceW10(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH4(),
                RichText(
                  text: TextSpan(
                    text: firstText,
                    style: sCaptionTextStyle.copyWith(
                      fontFamily: 'Gilroy',
                      color: colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
