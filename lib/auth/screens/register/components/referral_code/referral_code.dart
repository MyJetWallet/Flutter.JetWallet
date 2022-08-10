import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../notifier/referral_code_link_notipod.dart';

import 'components/no_referral_code.dart';
import 'components/show_referral_code_link.dart';
import 'components/valid_referral_code_outside.dart';

class ReferralCode extends HookWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(referralCodeLinkNotipod);
    final notifier = useProvider(referralCodeLinkNotipod.notifier);

    return SPaddingH24(
      child: GestureDetector(
        onTap: () {
          notifier.resetBottomSheetReferralCodeValidation();
          showReferralCode(context);
        },
        child: Column(
          children: [
            state.referralCodeValidation.maybeWhen(
              input: () {
                return const NoReferralCode();
              },
              loading: () {
                return const NoReferralCode();
              },
              valid: () {
                return const ValidReferralCodeOutSide();
              },
              invalid: () {
                return const NoReferralCode();
              },
              orElse: () {
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
