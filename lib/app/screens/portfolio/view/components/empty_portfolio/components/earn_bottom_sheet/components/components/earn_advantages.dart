import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../shared/providers/service_providers.dart';
import 'earn_advantage_item.dart';

class EarnAdvantages extends HookWidget {
  const EarnAdvantages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      children: [
        EarnAdvantageItem(
          text: intl.earnAdvantages_text1,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earnAdvantages_text2,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: '${intl.earnAdvantages_text3Part1}\n'
              '${intl.earnAdvantages_text3Part2}',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: '${intl.earnAdvantages_text4Part1}\n'
              '${intl.earnAdvantages_text4Part2}',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
