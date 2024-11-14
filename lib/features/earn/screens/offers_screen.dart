import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_offer_item.dart';
import 'package:jetwallet/features/earn/widgets/offers_overlay_content.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'OffersRouter')
class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    sAnalytics.allOffersScreenView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final store = EarnStore.of(context);
        final colors = SColorsLight();
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
                    offers.sort((a, b) => b.apyRate!.compareTo(a.apyRate!));

                    return EarnOfferItem(
                      isSingleOffer: offers.length == 1,
                      percentage: formatApyRate(offers.first.apyRate),
                      cryptoName: currency.description,
                      trailingIcon: NetworkIconWidget(
                        currency.iconUrl,
                        width: 40,
                        height: 40,
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheAnyOfferButton(
                          assetName: currency.symbol,
                          sourse: 'All offers',
                        );

                        if (offers.length > 1) {
                          VoidCallback? contentOnTap;

                          showBasicBottomSheet(
                            context: context,
                            button: BasicBottomSheetButton(
                              title: intl.earn_continue,
                              onTap: () {
                                contentOnTap?.call();
                              },
                            ),
                            children: [
                              OffersOverlayContent(
                                offers: offers,
                                currency: currency,
                                setParentOnTap: (onTap) {
                                  contentOnTap = onTap;
                                },
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
