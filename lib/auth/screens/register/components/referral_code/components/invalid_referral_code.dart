import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class InvalidReferralCode extends HookWidget {
  const InvalidReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Row(
      children: [
        const SCrossIcon(),
        const SpaceW10(),
        Text(
          intl.invalidReferralCodeLink_invalidReferralCodeLink,
          style: sCaptionTextStyle,
        ),
      ],
    );
  }
}
