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
  const OffersListWidget({super.key, required this.earnOffers});
  final List<EarnOfferClientModel> earnOffers;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final promotedOffers = earnOffers.where((offer) => offer.promotion).toList()
      ..sort((a, b) => (b.apyRate ?? Decimal.zero).compareTo(a.apyRate ?? Decimal.zero));

    return Observer(
      builder: (context) {
        return Column(
          children: [
            SBasicHeader(
              title: intl.earn_top_offers,
              buttonTitle: intl.earn_view_all,
              subtitle: intl.earn_most_profitable_earns,
              onTap: () {},
            ),
            ...promotedOffers.map((offer) {
              final currency = currencies.firstWhere(
                (currency) => currency.symbol == offer.assetId,
                orElse: () => CurrencyModel.empty(),
              );

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
                  print('Tapped on offer with ID: ${offer.id}');
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
