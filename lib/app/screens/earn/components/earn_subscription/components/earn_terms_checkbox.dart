import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnTermsCheckbox extends HookWidget {
  const EarnTermsCheckbox({
    Key? key,
    required this.firstText,
    required this.privacyPolicyText,
    required this.isChecked,
    required this.onCheckboxTap,
    required this.onPrivacyPolicyTap,
    required this.colors,
  }) : super(key: key);

  final String firstText;
  final String privacyPolicyText;
  final bool isChecked;
  final Function() onCheckboxTap;
  final Function() onPrivacyPolicyTap;
  final SimpleColors colors;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final checked = useState(isChecked);

    if (checked.value) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return Column(
      children: [
        Divider(
          color: colors.grey4,
        ),
        SizedBox(
          height: 77.0,
          child: Row(
            children: [
              Column(
                children: [
                  const SpaceH21(),
                  SIconButton(
                    onTap: () {
                      checked.value = !checked.value;
                      onCheckboxTap();
                    },
                    defaultIcon: icon,
                    pressedIcon: icon,
                  ),
                ],
              ),
              const SpaceW10(),
              Column(
                children: [
                  const SpaceH25(),
                  RichText(
                    text: TextSpan(
                      text: firstText,
                      style: sCaptionTextStyle.copyWith(
                        fontFamily: 'Gilroy',
                        color: colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: privacyPolicyText,
                          recognizer: TapGestureRecognizer()
                            ..onTap = onPrivacyPolicyTap,
                          style: TextStyle(
                            color: colors.blue,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
