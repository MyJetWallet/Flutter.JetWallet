import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

void showPasswordRequirements(
  BuildContext context,
) {

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    pinned: SBottomSheetHeader(
      name: intl.simple_card_password_requirements,
    ),
    children: [
      const _PasswordRequirements(),
    ],
  );
}

class _PasswordRequirements extends StatelessObserverWidget {
  const _PasswordRequirements();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022 ${intl.simple_card_password_requirements_1}',
            style: sBodyText1Style.copyWith(
              color: colors.black,
            ),
            maxLines: 2,
          ),
          Text(
            '\u2022 ${intl.simple_card_password_requirements_2}',
            style: sBodyText1Style.copyWith(
              color: colors.black,
            ),
            maxLines: 2,
          ),
          Text(
            '\u2022 ${intl.simple_card_password_requirements_3}',
            style: sBodyText1Style.copyWith(
              color: colors.black,
            ),
            maxLines: 2,
          ),
          Text(
            '\u2022 ${intl.simple_card_password_requirements_4}',
            style: sBodyText1Style.copyWith(
              color: colors.black,
            ),
            maxLines: 2,
          ),
          const SpaceH20(),
          const SDivider(),
          const SpaceH16(),
          Text(
            intl.simple_card_password_requirements_description,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 10,
          ),
          const SpaceH40(),
        ],
      ),
    );
  }
}
