import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnTermsCheckbox extends StatefulWidget {
  const EarnTermsCheckbox({
    Key? key,
    this.width,
    required this.firstText,
    required this.privacyPolicyText,
    required this.isChecked,
    required this.onCheckboxTap,
    required this.onPrivacyPolicyTap,
    required this.colors,
  }) : super(key: key);

  final double? width;
  final String firstText;
  final String privacyPolicyText;
  final bool isChecked;
  final Function() onCheckboxTap;
  final Function() onPrivacyPolicyTap;
  final SimpleColors colors;

  @override
  State<EarnTermsCheckbox> createState() => _EarnTermsCheckboxState();
}

class _EarnTermsCheckboxState extends State<EarnTermsCheckbox> {
  @override
  void initState() {
    checked = widget.isChecked;
    super.initState();
  }

  var checked = false;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    icon = checked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return Column(
      children: [
        Divider(
          color: widget.colors.grey4,
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
                      setState(() {
                        checked = !checked;
                      });

                      widget.onCheckboxTap();
                    },
                    defaultIcon: icon,
                    pressedIcon: icon,
                  ),
                ],
              ),
              const SpaceW10(),
              Column(
                children: [
                  const SpaceH22(),
                  Container(
                    width: widget.width ?? double.infinity,
                    margin: const EdgeInsets.only(
                      top: 2,
                    ),
                    child:
                      RichText(
                        text: TextSpan(
                          text: widget.firstText,
                          style: sCaptionTextStyle.copyWith(
                            fontFamily: 'Gilroy',
                            color: widget.colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: widget.privacyPolicyText,
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onPrivacyPolicyTap,
                              style: TextStyle(
                                color: widget.colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
