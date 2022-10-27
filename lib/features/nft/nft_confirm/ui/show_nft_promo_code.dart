import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_promo_code_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

void showNFTPromoCodeBottomSheet() {
  final colors = sKit.colors;

  sShowBasicModalBottomSheet(
    context: sRouter.navigatorKey.currentContext!,
    color: colors.white,
    pinned: ActionBottomSheetHeader(
      name: intl.actionReceive_receive,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    pinnedBottom: Material(
      color: colors.grey5,
      child: _PromoCodeBottom(
        context: sRouter.navigatorKey.currentContext!,
      ),
    ),
    children: [
      _PromoCodeBody(),
    ],
  );
}

class _PromoCodeBody extends StatelessObserverWidget {
  const _PromoCodeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).viewInsets.bottom -
          140,
      color: colors.grey5,
      child: Column(
        children: [
          Material(
            color: colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SStandardField(
                autofocus: true,
                isError: getIt.get<NFTPromoCodeStore>().isInputError,
                labelText: intl.showReferralCodeLink_referralCodeLink,
                controller: getIt.get<NFTPromoCodeStore>().promoCodeController,
                onChanged: (value) {
                  getIt.get<NFTPromoCodeStore>().updateReferralCode(
                        value,
                        null,
                      );
                },
                hideIconsIfError: false,
                onErase: () => getIt
                    .get<NFTPromoCodeStore>()
                    .clearBottomSheetReferralCode(),
                suffixIcons: [
                  SIconButton(
                    onTap: () =>
                        getIt.get<NFTPromoCodeStore>().pasteCodeReferralLink(),
                    defaultIcon: const SPasteIcon(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCodeBottom extends StatelessObserverWidget {
  const _PromoCodeBottom({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        SPaddingH24(
          child: SPrimaryButton4(
            active: true,
            name: intl.showBasicModalBottomSheet_continue,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SpaceH24(),
      ],
    );
  }
}
