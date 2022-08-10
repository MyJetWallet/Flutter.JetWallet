import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class NoReferralCode extends HookWidget {
  const NoReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SGiftReferralIcon(),
        const SpaceW12(),
        Text(
          intl.noReferralCode_havePromoCode,
          style: sButtonTextStyle,
        ),
      ],
    );
  }
}
