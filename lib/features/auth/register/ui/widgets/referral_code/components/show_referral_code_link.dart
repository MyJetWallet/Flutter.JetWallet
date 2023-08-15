import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../widgets/action_bottom_sheet_header.dart';
import 'invalid_referral_code.dart';
import 'loading_referral_code.dart';
import 'valid_referral_code.dart';

void showReferralCode(BuildContext context) {
  final colors = sKit.colors;

  sAnalytics.signInFlowPersonaReferralLinkScreenView();

  sShowBasicModalBottomSheet(
    context: context,
    expanded: true,
    color: colors.white,
    pinned: ActionBottomSheetHeader(
      name: intl.showReferralCodeLink_enterReferralCodeLink,
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
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
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
                isError: getIt.get<ReferallCodeStore>().isInputError,
                labelText: intl.showReferralCodeLink_referralCodeLink,
                controller:
                    getIt.get<ReferallCodeStore>().referralCodeController,
                onChanged: (value) {
                  getIt.get<ReferallCodeStore>().updateReferralCode(
                        value,
                        null,
                      );
                },
                hideIconsIfError: false,
                onErase: () => getIt
                    .get<ReferallCodeStore>()
                    .clearBottomSheetReferralCode(),
                suffixIcons: [
                  SIconButton(
                    onTap: () =>
                        getIt.get<ReferallCodeStore>().pasteCodeReferralLink(),
                    defaultIcon: const SPasteIcon(),
                    pressedIcon: const SPastePressedIcon(),
                  ),
                  SIconButton(
                    onTap: () =>
                        getIt.get<ReferallCodeStore>().scanAddressQr(context),
                    defaultIcon: const SQrCodeIcon(),
                    pressedIcon: const SQrCodePressedIcon(),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: colors.grey5,
            child: SPaddingH24(
              child: getIt
                  .get<ReferallCodeStore>()
                  .bottomSheetReferralCodeValidation
                  .maybeWhen(
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
                    children: const [
                      SpaceH24(),
                      ValidReferralCodeInside(),
                      SpaceH10(),
                    ],
                  );
                },
                invalid: () {
                  return Column(
                    children: const [
                      SpaceH24(),
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
              intl.showReferralCode_pasteReferralLinkOrCode,
              style: sCaptionTextStyle.copyWith(color: colors.grey6),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralCodeBottom extends StatelessObserverWidget {
  const _ReferralCodeBottom({
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
            active: getIt.get<ReferallCodeStore>().enableContinueButton,
            name: intl.showBasicModalBottomSheet_continue,
            onTap: () {
              sAnalytics.signInFlowPersonaReferralLinkContinue(
                  code: getIt.get<ReferallCodeStore>().referralCode ?? '');

              Navigator.pop(context);
            },
          ),
        ),
        const SpaceH24(),
      ],
    );
  }
}
