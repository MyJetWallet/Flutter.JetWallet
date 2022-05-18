import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class EarnSubscriptionPinned extends HookWidget {
  const EarnSubscriptionPinned({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 18,
            bottom: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${intl.earn_select} $name ${intl.earn_subscription}',
                style: sTextH4Style,
              ),
            ],
          ),
        ),
        SPaddingH24(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  intl.earn_asset,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
                Text(
                  intl.earn_apy,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
