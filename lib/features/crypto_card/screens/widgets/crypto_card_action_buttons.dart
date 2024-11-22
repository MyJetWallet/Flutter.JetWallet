import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/utils/show_card_settings_bootom_sheet.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CryptoCardActionButtons extends StatelessWidget {
  const CryptoCardActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ActionPannel(
        actionButtons: [
          SActionButton(
            onTap: () {},
            lable: intl.crypto_card_freeze,
            icon: Assets.svg.medium.freeze.simpleSvg(
              color: SColorsLight().white,
            ),
          ),
          SActionButton(
            lable: intl.crypto_card_change_pin,
            icon: Assets.svg.medium.pin.simpleSvg(
              color: SColorsLight().white,
            ),
            onTap: () {},
          ),
          SActionButton(
            lable: intl.crypto_card_settings,
            icon: Assets.svg.medium.settings.simpleSvg(
              color: SColorsLight().white,
            ),
            onTap: () {
              showCardSettingsBootomSheet(context);
            },
          ),
        ],
      ),
    );
  }
}
