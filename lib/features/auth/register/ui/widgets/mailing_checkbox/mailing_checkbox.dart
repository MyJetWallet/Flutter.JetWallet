import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class MailingCheckbox extends StatelessWidget {
  const MailingCheckbox({
    super.key,
    required this.isChecked,
    required this.onCheckboxTap,
  });

  final bool isChecked;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    icon = isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

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
                intl.mailingCheckbox_wantSubscibe,
                maxLines: 4,
                style: sCaptionTextStyle.copyWith(
                  fontFamily: 'Gilroy',
                  color: sKit.colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
