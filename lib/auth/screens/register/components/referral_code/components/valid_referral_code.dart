import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class ValidReferralCode extends HookWidget {
  const ValidReferralCode({
    Key? key,
    this.referralCode,
  }) : super(key: key);

  final String? referralCode;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Row(
      children: [
        const STickSelectedIcon(),
        const SpaceW10(),
        if (referralCode != null)
          Text(
            '${intl.your_referral_code} - $referralCode',
            style: sCaptionTextStyle,
          )
        else
          Text(
            intl.valid_referral_code,
            style: sCaptionTextStyle,
          )
      ],
    );
  }
}
