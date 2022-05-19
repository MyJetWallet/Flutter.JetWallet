import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/earn/provider/earn_offers_pod.dart';
import '../../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../earn_subscription/earn_subscriptions.dart';

class EarnItem extends HookWidget {
  const EarnItem({
    Key? key,
    required this.name,
    required this.apy,
  }) : super(key: key);

  final String name;
  final Decimal apy;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final earnOffers = useProvider(earnOffersPod);

    earnOffers.sort((a, b) => b.tiers[0].apy.compareTo(a.tiers[0].apy));

    final currentCurrency = currencyFrom(currencies, name);
    final currentOffers = earnOffers
        .where((element) => element.asset == name)
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
            child: Container(
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
                          ) ,
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
