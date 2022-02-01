import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_advantages.dart';
import 'components/earn_body_header.dart';
import 'components/earn_currencys_item.dart';

class EarnBody extends HookWidget {
  const EarnBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final colors = useProvider(sColorPod);

    return SPaddingH24(
      child: Column(
        children: [
          const SpaceH33(),
          EarnBodyHeader(
            currencies: currencies,
            colors: colors,
          ),
          const SpaceH32(),
          const EarnAdvantages(),
          const SpaceH32(),
          const SDivider(),
          const SpaceH32(),
          Row(
            children: [
              Text(
                'Start earning',
                style: sTextH4Style,
              ),
            ],
          ),
          const SpaceH24(),
          for (var element in currencies) ...[
            EarnCurrencysItem(element: element),
          ],
        ],
      ),
    );
  }
}
