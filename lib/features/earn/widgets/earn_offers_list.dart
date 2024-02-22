import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/chips_suggestion_m.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class OffersListWidget extends StatelessWidget {
  const OffersListWidget({
    super.key,
    required this.earnOffers,
    this.showTitle = true,
  });

  final List<EarnOfferClientModel> earnOffers;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final uniqueOffers = _getUniqueHighestApyOffers(earnOffers.where((offer) => offer.promotion).toList(), currencies);

    return Observer(
      builder: (context) {
        return Column(
          children: [
            if (showTitle)
              SBasicHeader(
                title: intl.earn_top_offers,
                buttonTitle: intl.earn_view_all,
                showLinkButton: earnOffers.isNotEmpty,
                subtitle: intl.earn_most_profitable_earns,
                onTap: () => context.router.push(const OffersRouter()),
              ),
            ...uniqueOffers.map((offer) {
              final currency = currencies.firstWhere(
                (currency) => currency.symbol == offer.assetId,
              );

              return ChipsSuggestionM(
                percentage: formatApyRate(offer.apyRate),
                cryptoName: currency.description,
                trailingIcon: offer.assetId.isNotEmpty
                    ? SNetworkSvg(
                        url: currency.iconUrl,
                        width: 40,
                        height: 40,
                      )
                    : const SizedBox.shrink(),
                onTap: () {
                  final groupOffers = earnOffers.where((o) => o.assetId == offer.assetId).toList();

                  if (groupOffers.length > 1) {
                    sShowBasicModalBottomSheet(
                      context: context,
                      scrollable: true,
                      children: [
                        OffersOverlayContent(
                          offers: groupOffers,
                          currency: currency,
                        ),
                      ],
                    );
                  } else {
                    context.router.push(
                      EarnDepositScreenRouter(offer: offer),
                    );
                  }
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }

  List<EarnOfferClientModel> _getUniqueHighestApyOffers(
    List<EarnOfferClientModel> offers,
    List<CurrencyModel> currencies,
  ) {
    final offersGroupedByCurrency = groupBy(offers, (EarnOfferClientModel offer) {
      return currencies.firstWhereOrNull((currency) => currency.symbol == offer.assetId)?.description ?? '';
    });

    final uniqueOffers = <EarnOfferClientModel>[];
    offersGroupedByCurrency.forEach((description, offers) {
      final highestApyOffer =
          offers.reduce((curr, next) => (curr.apyRate ?? Decimal.zero) > (next.apyRate ?? Decimal.zero) ? curr : next);
      uniqueOffers.add(highestApyOffer);
    });

    return uniqueOffers;
  }
}

String? formatApyRate(Decimal? apyRate) {
  if (apyRate == null) {
    return null;
  } else {
    return (apyRate * Decimal.fromInt(100)).toStringAsFixed(2);
  }
}
