import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

import '../../../../../../../widgets/action_bottom_sheet_header.dart';
import 'invalid_referral_code.dart';
import 'loading_referral_code.dart';
import 'valid_referral_code.dart';

void showReferralCode(BuildContext context) {
  final colors = sKit.colors;

  sAnalytics.enterReferralCodeScreenView();

  sShowBasicModalBottomSheet(
    context: context,
    color: colors.white,
    pinned: ActionBottomSheetHeader(
      name: intl.showReferralCode_enterReferralCode,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    pinnedBottom: Material(
      color: colors.grey5,
      child: _ReferralCodeBottom(
        context: context,
      ),
    ),
    children: [
      _ReferralCodeLinkBody(context: context),
    ],
  );
}

class _ReferralCodeLinkBody extends StatelessObserverWidget {
  const _ReferralCodeLinkBody({
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.grey5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SStandardField(
                autofocus: true,
                isError: getIt.get<ReferallCodeStore>().isInputError,
                labelText: intl.showReferralCode_referralCode,
                controller: getIt.get<ReferallCodeStore>().referralCodeController,
                onChanged: (value) {
                  getIt.get<ReferallCodeStore>().updateReferralCode(
                        value,
                        null,
                      );
                },
                hideIconsIfError: false,
                maxLines: 1,
                onErase: () => getIt.get<ReferallCodeStore>().clearBottomSheetReferralCode(),
                suffixIcons: [
                  SIconButton(
                    onTap: () {
                      sAnalytics.tapOnPasteButtonOnEnterReferralCode();
                      getIt.get<ReferallCodeStore>().pasteCodeReferralLink();
                    },
                    defaultIcon: Assets.svg.medium.copyAlt.simpleSvg(
                      width: 20,
                      color: sKit.colors.grey3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: colors.grey5,
                  child: SPaddingH24(
                    child: getIt.get<ReferallCodeStore>().bottomSheetReferralCodeValidation.maybeWhen(
                      loading: () {
                        return const Column(
                          children: [
                            SpaceH12(),
                            LoadingReferralCode(),
                            SpaceH10(),
                          ],
                        );
                      },
                      valid: () {
                        sAnalytics.validReferralCodeScreenView();

                        return const Column(
                          children: [
                            SpaceH12(),
                            ValidReferralCodeInside(),
                            SpaceH10(),
                          ],
                        );
                      },
                      invalid: () {
                        sAnalytics.errorInvalidReferralCode();

                        return const Column(
                          children: [
                            SpaceH12(),
                            InvalidReferralCode(),
                            SpaceH10(),
                          ],
                        );
                      },
                      orElse: () {
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                Container(
                  color: colors.grey5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 11.0,
                  ),
                  child: Text(
                    intl.showReferralCode_pasteReferralCode,
                    style: sCaptionTextStyle.copyWith(color: colors.grey2),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralCodeBottom extends StatelessObserverWidget {
  const _ReferralCodeBottom({
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        SPaddingH24(
          child: SPrimaryButton4(
            active: getIt.get<ReferallCodeStore>().enableContinueButton,
            name: intl.showBasicModalBottomSheet_continue,
            onTap: () {
              sAnalytics.tapOnContinueButtonOnEnterReferralCode();

              Navigator.pop(context);
            },
          ),
        ),
        const SpaceH24(),
      ],
    );
  }
}
