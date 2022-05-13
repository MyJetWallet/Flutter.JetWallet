import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class LoadingReferralCode extends HookWidget {
  const LoadingReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Row(
      children: [
        SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            color: colors.black,
            strokeWidth: 2.0,
          ),
        ),
        const SpaceW10(),
        Text(
          intl.checking,
          style: sCaptionTextStyle,
        ),
      ],
    );
  }
}
