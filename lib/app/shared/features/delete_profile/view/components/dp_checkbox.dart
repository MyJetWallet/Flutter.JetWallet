import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../notifier/delete_profile_notipod.dart';

class DPCheckbox extends HookWidget {
  const DPCheckbox({
    Key? key,
    this.indexCheckBox,
    required this.text,
    required this.onCheckboxTap,
  }) : super(key: key);

  final int? indexCheckBox;
  final String text;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    final state = useProvider(deleteProfileNotipod);

    icon = const SCheckboxSelectedIcon();

    return Container(
      padding: const EdgeInsets.only(left: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SIconButton(
            onTap: onCheckboxTap,
            defaultIcon: icon,
            pressedIcon: icon,
          ),
          const SpaceW10(),
          Flexible(
            child: Text(
              'I confirm that I followed all the steps and I want to delete my profile.',
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
