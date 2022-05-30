import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
import '../../../../shared/features/earn/provider/earn_offers_pod.dart';
import '../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/earn_active_item.dart';
import 'components/earn_item.dart';

class EarnItems extends HookWidget {
  const EarnItems({
    Key? key,
    required this.isActiveEarn,
    required this.emptyBalance,
  }) : super(key: key);

  final bool isActiveEarn;
  final bool emptyBalance;

  @override
  Widget build(BuildContext context) {
    final earnOffers = useProvider(earnOffersPod);
    final currencies = useProvider(currenciesPod);
    final useAnotherItem = useState(false);
    final currenciesByEarn = <String>[];
    final offersByEarn = <EarnOfferModel>[];
    final maxApyForCurrencies = <Decimal>[];
    var filteredOffers = earnOffers;

    earnOffers.sort((a, b) {
      final compare = b.currentApy.compareTo(a.currentApy);
      final aCurrency = currencyFrom(currencies, a.asset);
      final bCurrency = currencyFrom(currencies, b.asset);
      if (compare != 0) return compare;
      return aCurrency.weight.compareTo(bCurrency.weight);
    });

    if (!emptyBalance) {
      if (isActiveEarn) {
        useAnotherItem.value = true;
        filteredOffers = filteredOffers.where(
          (element) => element.amount > Decimal.zero,
        ).toList();
      } else {
        filteredOffers = filteredOffers.where(
          (element) => element.amount == Decimal.zero,
        ).toList();
        useAnotherItem.value = false;
      }
    }

    for (final element in filteredOffers) {
      if (!isActiveEarn) {
        if (!currenciesByEarn.contains(element.asset)) {
          currenciesByEarn.add(element.asset);
          maxApyForCurrencies.add(element.currentApy);
          final indexOfElement = currenciesByEarn.indexOf(element.asset);
          for (final tier in element.tiers) {
            if (maxApyForCurrencies[indexOfElement] < tier.apy) {
              maxApyForCurrencies[indexOfElement] = tier.apy;
            }
          }
        } else {
          final indexOfElement = currenciesByEarn.indexOf(element.asset);
          for (final tier in element.tiers) {
            if (maxApyForCurrencies[indexOfElement] < tier.apy) {
              maxApyForCurrencies[indexOfElement] = tier.apy;
            }
          }
        }
      } else {
        offersByEarn.add(element);
        maxApyForCurrencies.add(element.currentApy);
      }
    }

    if (emptyBalance) {
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

    return SPaddingH24(
      child: Column(
        children: [
          if (isActiveEarn) ...[
            for (final element in offersByEarn) ...[
              EarnActiveItem(earnOffer: element),
            ],
          ],
          if (!isActiveEarn) ...[
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
        ],
      ),
    );
  }
}
