import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/crypto_card/utils/show_crypto_card_change_pin_popup.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/crypto_card/store/main_crypto_card_store.dart';
import 'package:jetwallet/features/crypto_card/utils/show_delete_card_popup.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future showCardSettingsBootomSheet({
  required BuildContext context,
  required MainCryptoCardStore store,
}) async {
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
          leftIcon: Assets.svg.medium.document.simpleSvg(
            color: colors.gray6,
          ),
          onCardTap: () {},
        ),
        SEditable(
          lable: intl.crypto_card_settings_limit_settings,
          leftIcon: Assets.svg.medium.document.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            sRouter.popAndPush(const CryptoCardLimitsRoute());
          },
        ),
        SEditable(
          lable: intl.crypto_card_linked_assets,
          leftIcon: Assets.svg.medium.crypto.simpleSvg(
            color: colors.gray6,
          ),
          onCardTap: () {},
        ),
        SEditable(
          lable: intl.crypto_card_settings_change_pin,
          leftIcon: Assets.svg.medium.pin.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {
            showCryptoCardChangePinPopup(context);
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
          lable: intl.crypto_card_settings_documents,
          supplement: intl.crypto_card_settings_privacy_policy,
          leftIcon: Assets.svg.medium.document.simpleSvg(
            color: colors.blue,
          ),
          onCardTap: () {},
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
            Navigator.pop(context);
            final result = await showDeleteCardPopUp(context: context, cardLast4: store.cardLast4);
            if (result == true) {
              await store.deleteCard();
            }
          },
        ),
        const SpaceH58(),
      ],
    );
  }
}