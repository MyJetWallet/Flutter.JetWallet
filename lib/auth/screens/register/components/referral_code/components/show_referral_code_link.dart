import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../app/shared/features/actions/shared/components/action_bottom_sheet_header.dart';
import '../../../notifier/referral_code_link_notipod.dart';
import 'invalid_referral_code.dart';
import 'loading_referral_code.dart';
import 'valid_referral_code.dart';

void showReferralCode(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    pinned: const ActionBottomSheetHeader(
      name: 'Enter referral code/link',
    ),
    pinnedBottom: const _ReferralCodeBottom(),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ReferralCodeLinkBody()],
  );
}

class _ReferralCodeBottom extends HookWidget {
  const _ReferralCodeBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(referralCodeLinkNotipod);
    final notifier = useProvider(referralCodeLinkNotipod.notifier);

    return Material(
      color: colors.grey5,
      child: Column(
        children: [
          SPaddingH24(
            child: SPrimaryButton2(
              active: true,
              name: 'Continue',
              onTap: () {
                notifier.validateReferralCode(state.bottomSheetReferralCode!);
              },
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}

class _ReferralCodeLinkBody extends HookWidget {
  const _ReferralCodeLinkBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(referralCodeLinkNotipod);
    final notifier = useProvider(referralCodeLinkNotipod.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SPaddingH24(
              child: Material(
                color: colors.white,
                child: SStandardField(
                  errorNotifier: state.referralCodeErrorNotifier,
                  labelText: 'Referral code/link',
                  controller: state.referralCodeController,
                  onChanged: (value) => notifier.updateReferralCode(value),
                  suffixIcons: [
                    SIconButton(
                      onTap: () => notifier.pasteCodeReferralLink(),
                      defaultIcon: const SPasteIcon(),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: colors.grey5,
              child: SPaddingH24(
                child: state.bottomSheetReferralCodeValidation.maybeWhen(
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
                'Paste referral link or code. We recommend to click on the link'
                ' or scanning a QR code.',
                style: sCaptionTextStyle.copyWith(color: colors.grey6),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
