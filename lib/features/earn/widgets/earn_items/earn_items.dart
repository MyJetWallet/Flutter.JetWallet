import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';
import 'components/earn_active_item.dart';
import 'components/earn_item.dart';

class EarnItems extends StatelessObserverWidget {
  const EarnItems({
    Key? key,
    required this.isActiveEarn,
    required this.emptyBalance,
  }) : super(key: key);

  final bool isActiveEarn;
  final bool emptyBalance;

  @override
  Widget build(BuildContext context) {
    final earnOffers = EarnOffersStore.of(context).earnOffers;
    final currencies = sCurrencies.currencies;
    final currenciesByEarn = <String>[];
    final offersByEarn = <EarnOfferModel>[];
    final maxApyForCurrencies = <Decimal>[];
    List<EarnOfferModel> filteredOffers = earnOffers;

    earnOffers.sort((a, b) {
      final compare = b.currentApy.compareTo(a.currentApy);
      final aCurrency = currencyFrom(currencies, a.asset);
      final bCurrency = currencyFrom(currencies, b.asset);
      if (compare != 0) return compare;

      return bCurrency.weight.compareTo(aCurrency.weight);
    });

    if (!emptyBalance) {
      if (isActiveEarn) {
        EarnOffersStore.of(context).setUseAnotherItem(true);

        filteredOffers = filteredOffers
            .where(
              (element) => element.amount > Decimal.zero,
            )
            .toList();
      } else {
        filteredOffers = filteredOffers
            .where(
              (element) => element.amount == Decimal.zero,
            )
            .toList();

        EarnOffersStore.of(context).setUseAnotherItem(false);
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
                  apy: maxApyForCurrencies[currenciesByEarn.indexOf(element)],
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
                apy: maxApyForCurrencies[currenciesByEarn.indexOf(element)],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
