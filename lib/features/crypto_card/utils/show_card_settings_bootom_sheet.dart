import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_crypto_card_change_pin_popup.dart';
import 'package:jetwallet/features/crypto_card/utils/show_delete_card_popup.dart';
import 'package:jetwallet/features/crypto_card/utils/show_wallet_redirecting_popup.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_analytics/simple_analytics.dart';

Future<void> showCardSettingsBootomSheet({
  required BuildContext context,
  required MainCryptoCardStore store,
}) async {
  sAnalytics.viewCryptoCardSettings();
  await showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.crypto_card_settings,
    ),
    children: [
      _SettingsBody(store),
    ],
  );
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody(this.store);

  final MainCryptoCardStore store;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Column(
      children: [
        SEditable(
          lable: intl.crypto_card_settings_change_design,
          leftIcon: Assets.svg.medium.changeDesign.simpleSvg(
            color: colors.gray6,
          ),
          onCardTap: () {},
        ),
        SEditable(
          lable: intl.crypto_card_settings_limits,
          leftIcon: Assets.svg.medium.limits.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            sAnalytics.tapLimits();
            sRouter.popAndPush(
              CryptoCardLimitsRoute(
                cardId: store.cryptoCard.cardId,
              ),
            );
          },
        ),
        SEditable(
          lable: intl.crypto_card_linked_assets,
          leftIcon: Assets.svg.medium.crypto.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            sAnalytics.tapLinkedAssetsSettings();
            sRouter.popAndPush(const CryptoCardLinkedAssetsRoute());
          },
        ),
        SEditable(
          lable: intl.crypto_card_settings_change_pin,
          leftIcon: Assets.svg.medium.pin.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            sAnalytics.tapChangePIN();
            showCryptoCardChangePinPopup(context);
          },
        ),
        SEditable(
          lable: intl.crypto_card_settings_label_card,
          leftIcon: Assets.svg.medium.edit.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            sRouter.popAndPush(
              CryptoCardNameRoute(
                cardId: store.cryptoCard.cardId,
                initialLabel: store.cryptoCard.label,
                isCreateFlow: false,
              ),
            );
          },
        ),
        SEditable(
          lable: intl.crypto_card_settings_card_statements,
          leftIcon: Assets.svg.medium.bank.simpleSvg(
            color: colors.gray6,
          ),
          onCardTap: () {},
        ),
        SEditable(
          lable: intl.crypto_card_settings_add_to_wallet(
            Platform.isIOS ? intl.wallets_add_to_apple_wallet : intl.wallets_add_to_google_wallet,
          ),
          leftIcon: Assets.svg.medium.add.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            Navigator.pop(context);
            showWalletRedirectingPopup(context);
          },
        ),
        SEditable(
          lable: intl.crypto_card_settings_documents,
          supplement: intl.crypto_card_settings_privacy_policy,
          leftIcon: Assets.svg.medium.document.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            sAnalytics.tapDocuments();
          },
        ),
        SEditable(
          lable: intl.crypto_card_settings_delete_card,
          leftIcon: Assets.svg.medium.delete.simpleSvg(
            color: colors.red,
          ),
          lableStyle: STStyles.subtitle1.copyWith(
            color: colors.red,
          ),
          onCardTap: () async {
            sAnalytics.tapDeleteCard();
            Navigator.pop(context);
            final result = await showDeleteCardPopUp(context: context, cardLast4: store.cardLast4);
            if (result == true) {
              var isPinValid = false;
              await sRouter.push(
                PinScreenRoute(
                  union: const Change(),
                  isChangePhone: true,
                  onChangePhone: (String newPin) async {
                    isPinValid = true;
                    await sRouter.maybePop();
                  },
                ),
              );
              if (isPinValid) {
                await store.deleteCard();
              }
            }
          },
        ),
        const SpaceH58(),
      ],
    );
  }
}
