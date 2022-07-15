import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../widgets/action_bottom_sheet_header.dart';
import 'invalid_referral_code.dart';
import 'loading_referral_code.dart';
import 'valid_referral_code.dart';

void showReferralCode(BuildContext context) {
  final colors = getIt.get<SimpleKit>().colors;

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
    final colors = getIt.get<SimpleKit>().colors;

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
                isError: ReferallCodeStore.of(context).isInputError,
                labelText: intl.showReferralCodeLink_referralCodeLink,
                controller:
                    ReferallCodeStore.of(context).referralCodeController,
                onChanged: (value) {
                  ReferallCodeStore.of(context).updateReferralCode(
                    value,
                    null,
                  );
                },
                onErase: () => ReferallCodeStore.of(context)
                    .clearBottomSheetReferralCode(),
                suffixIcons: [
                  SIconButton(
                    onTap: () =>
                        ReferallCodeStore.of(context).pasteCodeReferralLink(),
                    defaultIcon: const SPasteIcon(),
                  ),
                  SIconButton(
                    onTap: () =>
                        ReferallCodeStore.of(context).scanAddressQr(context),
                    defaultIcon: const SQrCodeIcon(),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: colors.grey5,
            child: SPaddingH24(
              child: ReferallCodeStore.of(context)
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
                      ValidReferralCode(),
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
          child: SPrimaryButton2(
            active: ReferallCodeStore.of(context).enableContinueButton,
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
