import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/auth/register/ui/widgets/referral_code/components/loading_referral_code.dart';
import 'package:jetwallet/features/nft/nft_confirm/model/nft_promo_code_union.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_promo_code_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

void showNFTPromoCodeBottomSheet(Function() then) {
  final colors = sKit.colors;

  sShowBasicModalBottomSheet(
    context: sRouter.navigatorKey.currentContext!,
    color: colors.white,
    pinned: ActionBottomSheetHeader(
      name: intl.nft_promo_enter_code,
      showCloseIcon: false,
    ),
    then: (test) {

      then();
    },
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
                labelText: intl.nft_promo_code,
                controller: getIt.get<NFTPromoCodeStore>().promoCodeController,
                onChanged: (value) {
                  getIt.get<NFTPromoCodeStore>().updatePromoCode(
                        value,
                      );
                },
                hideIconsIfError: false,
                onErase: () =>
                    getIt.get<NFTPromoCodeStore>().clearBottomSheetPromoCode(),
                suffixIcons: [
                  SIconButton(
                    onTap: () =>
                        getIt.get<NFTPromoCodeStore>().pasteCodePromoLink(),
                    defaultIcon: const SPasteIcon(),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: colors.grey5,
            child: SPaddingH24(
              child: getIt.get<NFTPromoCodeStore>().promoStatus.maybeWhen(
                loading: () {
                  return Column(
                    children: const [
                      SpaceH24(),
                      LoadingReferralCode(),
                      SpaceH10(),
                    ],
                  );
                },
                valid: () {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH24(),
                      Row(
                        children: [
                          const STickSelectedIcon(),
                          const SpaceW10(),
                          Baseline(
                            baseline: 16,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_promo_valid,
                              style: sCaptionTextStyle,
                            ),
                          ),
                        ],
                      ),
                      const SpaceH10(),
                    ],
                  );
                },
                invalid: () {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH24(),
                      Row(
                        children: [
                          const SCrossIcon(),
                          const SpaceW10(),
                          Baseline(
                            baseline: 16,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              intl.nft_promo_invalid,
                              style: sCaptionTextStyle,
                            ),
                          ),
                        ],
                      ),
                      const SpaceH10(),
                    ],
                  );
                },
                orElse: () {
                  return const SizedBox();
                },
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
            active: getIt.get<NFTPromoCodeStore>().promoStatus is Valid &&
                getIt.get<NFTPromoCodeStore>().discount != null,
            name: intl.showBasicModalBottomSheet_continue,
            onTap: () {

              getIt.get<NFTPromoCodeStore>().setSaved(true);

              Navigator.pop(context);
            },
          ),
        ),
        const SpaceH24(),
      ],
    );
  }
}
