import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/chips_suggestion_m.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';

@RoutePage(name: 'OffersRouter')
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final store = EarnStore.of(context);
        final offers = store.earnPromotionOffers;
        final currencies = sSignalRModules.currenciesList;
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                GlobalBasicAppBar(
                  hasRightIcon: false,
                  title: intl.earn_all_offers,
                ),
                ...offers.map((offer) {
                  final currency = currencies.firstWhere(
                    (currency) => currency.symbol == offer.assetId,
                  );

                  return ChipsSuggestionM(
                    percentage: offer.apyRate.toString(),
                    cryptoName: offer.assetId,
                    trailingIcon: offer.assetId.isNotEmpty
                        ? SNetworkSvg(
                            url: currency.iconUrl,
                            width: 40,
                            height: 40,
                          )
                        : const SizedBox.shrink(),
                    onTap: () {},
                  );
                }).toList(),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
