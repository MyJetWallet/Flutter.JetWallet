import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ChangeOrderWidget extends StatelessWidget {
  const ChangeOrderWidget({
    required this.onPressedDone,
  });

  final void Function() onPressedDone;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intl.my_wallets_change_order,
                    style: sSubtitle3Style,
                  ),
                  Text(
                    intl.my_wallets_move_wallets,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey2,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: colors.grey5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: onPressedDone,
                child: Text(
                  intl.my_wallets_button_done,
                  style: sTextButtonStyle.copyWith(
                    color: colors.purple,
                  ),
                ),
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
