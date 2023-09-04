import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/account/delete_profile/store/delete_profile_store.dart';
import 'package:simple_kit/simple_kit.dart';

class DPCheckbox extends StatelessObserverWidget {
  const DPCheckbox({
    super.key,
    this.indexCheckBox,
    required this.text,
    required this.onCheckboxTap,
  });

  final int? indexCheckBox;
  final String text;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    final store = getIt.get<DeleteProfileStore>();

    icon = store.confitionCheckbox
        ? const SCheckboxSelectedIcon()
        : const SCheckboxIcon();

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
              intl.deleteProfileConditions_checkbox,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
