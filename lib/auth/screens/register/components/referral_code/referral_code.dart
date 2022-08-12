import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../notifier/referral_code_link_notipod.dart';

import 'components/show_referral_code_link.dart';

class ReferralCode extends HookWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(referralCodeLinkNotipod);
    final notifier = useProvider(referralCodeLinkNotipod.notifier);
    final intl = useProvider(intlPod);
    late String text;
    late Widget icon;
    state.referralCodeValidation.maybeWhen(
      valid: () {
        text = intl.validReferralCode_validReferralCode;
        icon = const SCompleteSolidIcon();
      },
      orElse: () {
        text = intl.noReferralCode_havePromoCode;
        icon = const SGiftReferralIcon();
      },
    );
    return SPaddingH24(
      child: SSecondaryButton3(
        active: true,
        name: text,
        icon: icon,
        onTap: () {
          notifier.resetBottomSheetReferralCodeValidation();
          showReferralCode(context);
        },
      ),
    );
  }
}
