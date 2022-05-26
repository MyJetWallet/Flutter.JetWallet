import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../portfolio/view/components/empty_portfolio/components/earn_bottom_sheet/components/components/earn_advantage_item.dart';


class EarnPageAdvantages extends HookWidget {
  const EarnPageAdvantages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      children: [
        EarnAdvantageItem(
          text: intl.earn_advantage1,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earn_advantage2,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earn_advantage3,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earn_advantage4,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
