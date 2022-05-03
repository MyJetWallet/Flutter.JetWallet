import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class MailingCheckbox extends HookWidget {
  const MailingCheckbox({
    Key? key,
    required this.isChecked,
    required this.onCheckboxTap,
  }) : super(key: key);

  final bool isChecked;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    late Widget icon;

    if (isChecked) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SIconButton(
          onTap: onCheckboxTap,
          defaultIcon: icon,
          pressedIcon: icon,
        ),
        const SpaceW10(),
        Expanded(
          child: Column(
            children: [
              const SpaceH4(),
              Text(
                'I want to subscribe to the marketing communications ' +
                    'upon the new Products, Services and features of Simple',
                maxLines: 4,
                style: sCaptionTextStyle.copyWith(
                  fontFamily: 'Gilroy',
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
