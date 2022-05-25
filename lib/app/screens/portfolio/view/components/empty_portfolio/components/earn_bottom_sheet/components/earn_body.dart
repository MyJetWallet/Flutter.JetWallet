import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../shared/models/currency_model.dart';
import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_advantages.dart';
import 'components/earn_currencys_item.dart';

class EarnBody extends HookWidget {
  const EarnBody({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function(CurrencyModel) onTap;

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);
    final intl = useProvider(intlPod);

    final sortedByApyCurrencies = currencies;
    sortedByApyCurrencies.sort((a, b) =>
        b.apy.compareTo(a.apy),
    );

    return Column(
      children: [
        const SPaddingH24(
          child: EarnAdvantages(),
        ),
        const SpaceH32(),
        const SPaddingH24(
          child: SDivider(),
        ),
        const SpaceH32(),
        SPaddingH24(
          child: Row(
            children: [
              Text(
                intl.earnBody_startEarn,
                style: sTextH4Style,
              ),
            ],
          ),
        ),
        const SpaceH24(),
        for (var element in sortedByApyCurrencies) ...[
          if (element.apy.toDouble() > 0)
            EarnCurrencyItem(
              element: element,
              onTap: () => onTap(element),
            ),
        ],
      ],
    );
  }
}
