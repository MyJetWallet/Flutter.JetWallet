import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ChangeOrderWidget extends StatelessWidget {
  const ChangeOrderWidget({
    required this.onPressedDone,
  });

  final void Function() onPressedDone;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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
                      color: colors.grey2,
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
