import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class ChangeOrderWidget extends StatelessWidget {
  const ChangeOrderWidget({
    required this.onPressedDone,
  });

  final void Function() onPressedDone;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      color: colors.white,
      child: Column(
        children: [
          const SpaceH9(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intl.my_wallets_change_order,
                    style: STStyles.subtitle2,
                  ),
                  Text(
                    intl.my_wallets_move_wallets,
                    style: STStyles.body2Medium.copyWith(
                      color: colors.gray8,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              SButtonContext(
                type: SButtonContextType.iconedSmall,
                onTap: onPressedDone,
                text: intl.my_wallets_button_done,
                icon: Assets.svg.medium.checkmark,
              ),
            ],
          ),
          const SpaceH10(),
          const SDivider(),
        ],
      ),
    );
  }
}
