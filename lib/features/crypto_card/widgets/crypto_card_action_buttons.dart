import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_card_settings_bootom_sheet.dart';
import 'package:jetwallet/features/crypto_card/utils/show_freeze_crypto_card_popup.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CryptoCardActionButtons extends StatelessWidget {
  const CryptoCardActionButtons({
    required this.store,
    required this.cardIsFrozen,
    super.key,
  });

  final MainCryptoCardStore store;
  final bool cardIsFrozen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: AnimatedCrossFade(
        firstChild: _buildUnfreezeButtons(context),
        secondChild: _buildFreezeButtons(),
        crossFadeState: cardIsFrozen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildFreezeButtons() {
    return ActionPannel(
      actionButtons: [
        SActionButton(
          onTap: () {
            store.unfreezeCard();
          },
          lable: intl.crypto_card_unfreeze,
          icon: Assets.svg.medium.freeze.simpleSvg(
            color: SColorsLight().white,
          ),
        ),
      ],
    );
  }

  Widget _buildUnfreezeButtons(BuildContext context) {
    return ActionPannel(
      actionButtons: [
        SActionButton(
          onTap: () {
            showFreezeCryptoCardPopup(
              context: context,
              onFreezePressed: () {
                store.freezeCard();
              },
            );
          },
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
            showCardSettingsBootomSheet(context: context, store: store);
          },
        ),
      ],
    );
  }
}
