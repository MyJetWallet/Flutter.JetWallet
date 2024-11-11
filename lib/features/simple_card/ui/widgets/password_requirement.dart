import 'package:flutter/material.dart';
import 'package:simple_kit/modules/icons/20x20/public/list_checkmark/simple_check_list_icon.dart';
import 'package:simple_kit/modules/icons/20x20/public/list_checkmark/simple_minus_list_icon.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class PasswordRequirement extends StatelessWidget {
  const PasswordRequirement({
    super.key,
    required this.isApproved,
    required this.name,
  });

  final bool isApproved;
  final String name;

  @override
  Widget build(BuildContext context) {
    final mainColor = isApproved ? SColorsLight().blue : SColorsLight().black;

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH6(),
          Row(
            children: [
              if (isApproved) const SCheckListIcon() else const SMinusListIcon(),
              const SpaceW12(),
              Text(
                name,
                style: STStyles.body2Medium.copyWith(
                  color: mainColor,
                ),
              ),
            ],
          ),
          const SpaceH6(),
        ],
      ),
    );
  }
}
