import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../earn_subscription/earn_subscriptions.dart';

class EarnItem extends StatelessObserverWidget {
  const EarnItem({
    super.key,
    required this.name,
    required this.apy,
  });

  final String name;
  final Decimal apy;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final earnOffers = EarnOffersStore.of(context).earnOffers;

    earnOffers.sort((a, b) {
      final compare = b.tiers[0].apy.compareTo(a.tiers[0].apy);
      final aCurrency = currencyFrom(currencies, a.asset);
      final bCurrency = currencyFrom(currencies, b.asset);
      if (compare != 0) return compare;

      return bCurrency.weight.compareTo(aCurrency.weight);
    });

    final currentCurrency = currencyFrom(currencies, name);
    final currentOffers = earnOffers
        .where(
          (element) => element.asset == name && element.amount == Decimal.zero,
        )
        .toList();

    return Column(
      children: [
        InkWell(
          highlightColor: colors.grey5,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            showSubscriptionBottomSheet(
              context: context,
              offers: currentOffers,
              currency: currentCurrency,
            );
          },
          child: Ink(
            height: 88,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: colors.grey4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SNetworkSvg24(
                          url: currentCurrency.iconUrl,
                        ),
                        const SpaceW10(),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 3,
                          ),
                          child: Text(
                            currentCurrency.description,
                            style: sSubtitle2Style.copyWith(
                              color: colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$apy%',
                      style: sTextH2Style.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SpaceH10(),
      ],
    );
  }
}
