import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/chips_suggestion_m.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/bottom_sheets/components/basic_bottom_sheet/show_basic_modal_bottom_sheet.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'OffersRouter')
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    sAnalytics.allOffersScreenView();
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final store = EarnStore.of(context);
        final colors = sKit.colors;
        final currencies = sSignalRModules.currenciesList;

        return SPageFrame(
          loaderText: '',
          color: colors.white,
          header: GlobalBasicAppBar(
            title: intl.earn_all_offers,
            hasRightIcon: false,
          ),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final assetId = store.groupedOffers.keys.elementAt(index);
                    final offers = store.groupedOffers[assetId] ?? [];
                    final currency = currencies.firstWhere((currency) => currency.symbol == assetId);

                    return ChipsSuggestionM(
                      isSingleOffer: offers.length == 1,
                      percentage: formatApyRate(offers.first.apyRate),
                      cryptoName: currency.description,
                      trailingIcon: SNetworkSvg(
                        url: currency.iconUrl,
                        width: 40,
                        height: 40,
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheAnyOfferButton(
                          assetName: currency.symbol,
                          sourse: 'All offers',
                        );

                        if (offers.length > 1) {
                          offers.sort((a, b) => b.apyRate!.compareTo(a.apyRate!));
                          sShowBasicModalBottomSheet(
                            context: context,
                            scrollable: true,
                            children: [
                              OffersOverlayContent(
                                offers: offers,
                                currency: currency,
                              ),
                            ],
                          );
                        } else {
                          context.router.push(
                            EarnDepositScreenRouter(offer: offers.first),
                          );
                        }
                      },
                    );
                  },
                  childCount: store.groupedOffers.keys.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.bottom),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatApyRate(Decimal? apyRate) {
    if (apyRate == null) {
      return 'N/A';
    } else {
      final percentage = (apyRate * Decimal.fromInt(100)).toStringAsFixed(2);
      return percentage;
    }
  }
}
