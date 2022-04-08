import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../app/shared/features/actions/shared/components/action_bottom_sheet_header.dart';

void showReferralCodeLink(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    pinned: const ActionBottomSheetHeader(
      name: 'Enter referral code/link',
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ReferralCodeLinkBody()],
  );
}

class _ReferralCodeLinkBody extends HookWidget {
  const _ReferralCodeLinkBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SPaddingH24(
              child: Material(
                color: colors.white,
                child: const SStandardField(
                  // errorNotifier: state.addressErrorNotifier,
                  labelText: 'Referral code/link',
                  // focusNode: state.addressFocus,
                  // controller: state.addressController,
                  // onChanged: (value) => notifier.updateAddress(value),
                  // onErase: () => notifier.eraseAddress(),
                  suffixIcons: [
                    SIconButton(
                      // onTap: () => notifier.pasteAddress(),
                      defaultIcon: SPasteIcon(),
                    ),
                    SIconButton(
                      // onTap: () => notifier.scanAddressQr(context),
                      defaultIcon: SQrCodeIcon(),
                    ),
                  ],
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
        Material(
          color: colors.grey5,
          child: SPaddingH24(
            child: SPrimaryButton2(
              active: true,
              name: 'Continue',
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
