import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/chips_suggestion_m.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class OffersListWidget extends StatelessWidget {
  const OffersListWidget({super.key, required this.offers});
  final List<EarnOfferClientModel> offers;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final uniqueOffers = _getUniqueHighestApyOffers(offers, currencies);

    return Observer(
      builder: (context) {
        return Column(
          children: [
            /// header
            SBasicHeader(
              title: intl.earn_top_offers,
              buttonTitle: intl.earn_view_all,
              subtitle: intl.earn_most_profitable_earns,
              onTap: () {},
            ),
            ...uniqueOffers.map((offer) {
              final currency = currencies.firstWhere(
                (currency) => currency.symbol == offer.assetId,
                orElse: () => CurrencyModel.empty(),
              );

              /// offers
              return ChipsSuggestionM(
                percentage: offer.apyRate.toString(),
                cryptoName: currency.description,
                trailingIcon: currency.iconUrl.isNotEmpty
                    ? SNetworkSvg(
                        url: currency.iconUrl,
                        width: 40,
                        height: 40,
                      )
                    : const SizedBox.shrink(),
                onTap: () {
                  final relatedOffers = offers.where((o) {
                    final offerCurrency = currencies.firstWhereOrNull((c) => c.symbol == o.assetId);
                    return offerCurrency?.description == currency.description;
                  }).toList();

                  for (final relatedOffer in relatedOffers) {
                    print(
                      'Currency: ${currency.description}, Offer ID: ${relatedOffer.id}, APY Rate: ${relatedOffer.apyRate}',
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
      final currency = currencies.firstWhereOrNull((currency) => currency.symbol == offer.assetId);
      return currency?.description ?? 'Unknown';
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
