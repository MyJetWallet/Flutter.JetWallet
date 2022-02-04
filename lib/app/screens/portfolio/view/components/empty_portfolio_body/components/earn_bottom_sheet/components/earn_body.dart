import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/models/currency_model.dart';
import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_advantages.dart';
import 'components/earn_body_header.dart';
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
    final colors = useProvider(sColorPod);

    return Column(
      children: [
        const SpaceH33(),
        SPaddingH24(
          child: EarnBodyHeader(
            currencies: currencies,
            colors: colors,
          ),
        ),
        const SpaceH32(),
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
                'Start earning',
                style: sTextH4Style,
              ),
            ],
          ),
        ),
        const SpaceH24(),
        for (var element in currencies) ...[
          if (element.apy > 0)
            EarnCurrencyItem(
              element: element,
              onTap: () => onTap(element),
            ),
        ],
      ],
    );
  }
}
