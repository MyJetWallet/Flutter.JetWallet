import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/features/earn/provider/earn_offers_pod.dart';
import 'components/earn_item.dart';

class EarnItems extends HookWidget {
  const EarnItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final earnOffers = useProvider(earnOffersPod);

    final currenciesByEarn = <String>[];
    final maxApyForCurrencies = <Decimal>[];

    for (final element in earnOffers) {
      if (!currenciesByEarn.contains(element.asset)) {
        currenciesByEarn.add(element.asset);
        maxApyForCurrencies.add(element.currentApy);
      } else {
        final indexOfElement = currenciesByEarn.indexOf(element.asset);
        if (maxApyForCurrencies[indexOfElement] < element.currentApy) {
          maxApyForCurrencies[indexOfElement] = element.currentApy;
        }
      }
    }

    return SliverToBoxAdapter(
      child: SPaddingH24(
        child: Column(
          children: [
            const SpaceH20(),
            for (final element in currenciesByEarn) ...[
              EarnItem(
                name: element,
                apy: maxApyForCurrencies[
                  currenciesByEarn.indexOf(element)
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
