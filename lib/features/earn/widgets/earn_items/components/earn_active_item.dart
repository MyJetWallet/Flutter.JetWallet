import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

import '../../earn_offer_details/earn_offer_details.dart';
import 'earn_item_progress.dart';

class EarnActiveItem extends StatelessObserverWidget {
  const EarnActiveItem({
    super.key,
    required this.earnOffer,
  });

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;
    final earnOffers = EarnOffersStore.of(context).earnOffers;

    earnOffers.sort((a, b) {
      final compare = b.currentApy.compareTo(a.currentApy);
      final aCurrency = currencyFrom(currencies, a.asset);
      final bCurrency = currencyFrom(currencies, b.asset);
      if (compare != 0) return compare;

      return bCurrency.weight.compareTo(aCurrency.weight);
    });

    final currentCurrency = currencyFrom(currencies, earnOffer.asset);

    var processWidth = 0.0;
    final currentWidth = MediaQuery.of(context).size.width;

    if (earnOffer.endDate != null) {
      final firstDate =
          DateTime.parse(earnOffer.startDate).toLocal().millisecondsSinceEpoch;
      final lastDate =
          DateTime.parse(earnOffer.endDate!).toLocal().millisecondsSinceEpoch;
      final currentDate = DateTime.now().toLocal().millisecondsSinceEpoch;
      processWidth =
          (currentDate - firstDate) / (lastDate - firstDate) * currentWidth;
    }

    final isWidthDifferenceSmall = (currentWidth - processWidth) < 16;
    final showProgress =
        (earnOffer.amount.toDouble() / earnOffer.maxAmount.toDouble()) >= 0.3;

    Color getColorByTiers() {
      if (earnOffer.offerTag == 'Hot') {
        if (earnOffer.tiers.length == 1 ||
            (earnOffer.tiers[0].active &&
                !earnOffer.tiers[1].active &&
                !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
          return colors.orange;
        } else if (earnOffer.tiers.length == 2 ||
            (earnOffer.tiers[1].active &&
                !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
          return colors.brown;
        } else {
          return colors.darkBrown;
        }
      }
      if (earnOffer.tiers.length == 1 ||
          (earnOffer.tiers[0].active &&
              !earnOffer.tiers[1].active &&
              !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
        return colors.seaGreen;
      } else if (earnOffer.tiers.length == 2 ||
          (earnOffer.tiers[1].active &&
              !(earnOffer.tiers.length > 2 && earnOffer.tiers[2].active))) {
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
              assetName: currentCurrency.description,
            );
          },
          child: Ink(
            height: 88,
            width: double.infinity,
            color: Colors.transparent,
            child: DecoratedBox(
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
                      width: processWidth > 20 ? processWidth : 20,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SNetworkSvg24(
                                    url: currentCurrency.iconUrl,
                                  ),
                                  const SpaceW10(),
                                  Expanded(
                                    child: Text(
                                      '${currentCurrency.description} '
                                      '${earnOffer.offerTag == 'Hot' ? intl.earn_hot : intl.earn_flexible}',
                                      style: sSubtitle2Style.copyWith(
                                        color: colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  children: [
                                    if (earnOffer.offerTag == 'Hot' &&
                                        showProgress) ...[
                                      EarnItemProgress(offer: earnOffer),
                                      const SpaceW10(),
                                    ] else ...[
                                      const SpaceW34(),
                                    ],
                                    Text(
                                      volumeFormat(
                                        decimal: earnOffer.amount,
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
                        ),
                        const SpaceW20(),
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
