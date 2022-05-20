import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/earn_offers_model.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/earn/provider/earn_offers_pod.dart';
import '../../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../earn_offer_details/earn_offer_details.dart';
import 'earn_item_progress.dart';

class EarnActiveItem extends HookWidget {
  const EarnActiveItem({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final earnOffers = useProvider(earnOffersPod);
    final intl = useProvider(intlPod);

    earnOffers.sort((a, b) => b.currentApy.compareTo(a.currentApy));

    final currentCurrency = currencyFrom(currencies, earnOffer.asset);

    var processWidth = 0.0;
    final currentWidth = MediaQuery.of(context).size.width;

    if (earnOffer.endDate != null) {
      final firstDate = DateTime
          .parse(earnOffer.startDate)
          .toLocal()
          .millisecondsSinceEpoch;
      final lastDate = DateTime
          .parse(earnOffer.endDate!)
          .toLocal()
          .millisecondsSinceEpoch;
      final currentDate = DateTime
          .now()
          .toLocal()
          .millisecondsSinceEpoch;
      processWidth = (currentDate - firstDate) /
          (lastDate - firstDate) *
          currentWidth;
    }

    final isWidthDifferenceSmall = (currentWidth - processWidth) < 16;

    Color getColorByTiers() {
      if (earnOffer.offerTag == 'Hot') {
        if (earnOffer.tiers.length == 1 ||
            (earnOffer.tiers[0].active
              && !earnOffer.tiers[1].active
              && !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
          return colors.orange;
        } else if (earnOffer.tiers.length == 2 ||
            (earnOffer.tiers[1].active
              && !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
          return colors.brown;
        } else {
          return colors.darkBrown;
        }
      }
      if (earnOffer.tiers.length == 1 ||
          (earnOffer.tiers[0].active
            && !earnOffer.tiers[1].active
            && !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
        return colors.seaGreen;
      } else if (earnOffer.tiers.length == 2 ||
          (earnOffer.tiers[1].active
            && !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
        return colors.leafGreen;
      } else {
        return colors.aquaGreen;
      }
    }

    return Column(
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            showEarnOfferDetails(
              context: context,
              earnOffer: earnOffer,
            );
          },
          child: Ink(
            height: 88,
            width: double.infinity,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: earnOffer.offerTag == 'Hot'
                    ? colors.yellowLight
                    : colors.greenLight,
              ),
              child: Stack(
                children: [
                  if (processWidth != 0) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          bottomLeft: const Radius.circular(16),
                          topRight: isWidthDifferenceSmall
                              ? const Radius.circular(16)
                              : Radius.zero,
                          bottomRight: isWidthDifferenceSmall
                              ? const Radius.circular(16)
                              : Radius.zero,
                        ),
                        color: earnOffer.offerTag == 'Hot'
                            ? colors.yellowDarkLight.withOpacity(0.1)
                            : colors.greenDarkLight.withOpacity(0.1),
                      ),
                      width: processWidth,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SNetworkSvg24(
                                  url: currentCurrency.iconUrl,
                                ),
                                const SpaceW10(),
                                Text(
                                  '${currentCurrency.description} '
                                      '${earnOffer.offerTag == 'Hot'
                                          ? intl.earn_hot
                                          : intl.earn_flexible}',
                                  style: sSubtitle2Style.copyWith(
                                    color: colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  if (earnOffer.offerTag == 'Hot') ...[
                                    EarnItemProgress(offer: earnOffer),
                                    const SpaceW10(),
                                  ] else ...[
                                    const SpaceW34(),
                                  ],
                                  Text(
                                    volumeFormat(
                                      decimal: earnOffer.amountBaseAsset,
                                      accuracy: currentCurrency.accuracy,
                                      symbol: currentCurrency.symbol,
                                    ),
                                    style: sBodyText2Style.copyWith(
                                      color: colors.grey1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${earnOffer.currentApy}%',
                          style: sTextH2Style.copyWith(
                            color: getColorByTiers(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SpaceH10(),
      ],
    );
  }
}
