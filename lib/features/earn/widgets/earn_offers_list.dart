import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/earn_offer_item.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class OffersListWidget extends StatelessWidget {
  const OffersListWidget({
    super.key,
    required this.filteredOffersGroupedByCurrency,
    required this.highestApyOffers,
    this.showTitle = true,
  });

  final Map<String, List<EarnOfferClientModel>> filteredOffersGroupedByCurrency;
  final Map<String, EarnOfferClientModel> highestApyOffers;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    return Observer(
      builder: (context) {
        return Column(
          children: [
            if (showTitle)
              SBasicHeader(
                title: intl.earn_top_offers,
                buttonTitle: intl.earn_view_all,
                showLinkButton: filteredOffersGroupedByCurrency.isNotEmpty,
                subtitle: intl.earn_most_profitable_earns,
                onTap: () {
                  sAnalytics.tapOnTheViewAllTopOffersButton();
                  context.router.push(const OffersRouter());
                },
              ),
            ...filteredOffersGroupedByCurrency.entries.map((entry) {
              final currencyDescription = entry.key;
              final currencyOffers = entry.value;
              final currency = currencies.firstWhere(
                (currency) => currency.description == currencyDescription,
                orElse: () => CurrencyModel.empty(),
              );

              if (!currencyOffers.any(
                (element) => element.status == EarnOfferStatus.activeShow,
              )) {
                return const Offstage();
              }

              return EarnOfferItem(
                isSingleOffer: currencyOffers.length == 1,
                percentage: formatApyRate(
                  highestApyOffers[currencyDescription]?.apyRate,
                ),
                cryptoName: currency.description,
                trailingIcon: SNetworkSvg(
                  url: currency.iconUrl,
                  width: 40,
                  height: 40,
                ),
                onTap: () {
                  sAnalytics.tapOnTheAnyOfferButton(
                    assetName: currencyOffers.first.assetId,
                    sourse: 'Main earns',
                  );
                  if (currencyOffers
                          .where(
                            (element) => element.status == EarnOfferStatus.activeShow,
                          )
                          .length >
                      1) {
                    sShowBasicModalBottomSheet(
                      context: context,
                      scrollable: true,
                      children: [
                        OffersOverlayContent(
                          offers: currencyOffers,
                          currency: currency,
                        ),
                      ],
                    );
                  } else {
                    context.router.push(
                      EarnDepositScreenRouter(offer: currencyOffers.first),
                    );
                  }
                },
              );
            }),
          ],
        );
      },
    );
  }
}

String? formatApyRate(Decimal? apyRate) {
  if (apyRate == null) {
    return null;
  } else {
    return (apyRate * Decimal.fromInt(100)).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
  }
}
