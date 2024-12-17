import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_card_settings_bootom_sheet.dart';
import 'package:jetwallet/features/crypto_card/utils/show_freeze_crypto_card_popup.dart';
import 'package:jetwallet/features/crypto_card/utils/show_unfreeze_crypto_card_popup.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:simple_analytics/simple_analytics.dart';

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
        secondChild: _buildFreezeButtons(context),
        crossFadeState: cardIsFrozen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildFreezeButtons(BuildContext context) {
    return ActionPannel(
      actionButtons: [
        SActionButton(
          onTap: () {
            sAnalytics.tapCardUnfreezeButton();
            showUnfreezeCryptoCardPopup(
              context: context,
              onUnfreezePressed: () {
                store.unfreezeCard();
              },
            );
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
          lable: intl.crypto_card_show_details,
          icon: Assets.svg.medium.show.simpleSvg(
            color: SColorsLight().white,
          ),
          onTap: () {
            getIt.get<EventBus>().fire(FlipCryptoCard());
          },
        ),
        SActionButton(
          onTap: () {
            sAnalytics.tapFreezeCardCrypto();
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
          lable: intl.crypto_card_settings,
          icon: Assets.svg.medium.settings.simpleSvg(
            color: SColorsLight().white,
          ),
          onTap: () {
            sAnalytics.tapSettings();
            showCardSettingsBootomSheet(context: context, store: store);
          },
        ),
      ],
    );
  }
}
