import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/basic_banner.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:jetwallet/features/earn/widgets/earn_positions_list.dart';
import 'package:jetwallet/features/earn/widgets/price_header.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'EarnRouter')
class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  final ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('earn-screen-key'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          sAnalytics.earnMainScreenView();
        }
      },
      child: Provider<EarnStore>(
        create: (context) => EarnStore(),
        builder: (context, child) {
          return _EarnView(controller: controller);
        },
      ),
    );
  }
}

class _EarnView extends StatelessWidget {
  const _EarnView({
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<EarnStore>(context);
    final colors = sKit.colors;
    return SPageFrame(
      loaderText: '',
      color: colors.white,
      header: SMarketHeaderClosed(
        color: colors.white,
        title: intl.earn_earn,
      ),
      child: Observer(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              if (store.earnPositions.isNotEmpty)
                SliverToBoxAdapter(
                  child: SBasicBanner(text: intl.earn_funds_are_calculated_based_on_the_current_value),
                ),
              SliverToBoxAdapter(
                child: SPriceHeader(
                  totalSum: store.isBalanceHide
                      ? marketFormat(
                          decimal: store.positionsTotalValueInVaseCurrency,
                          symbol: sSignalRModules.baseCurrency.symbol,
                          accuracy: 2,
                        )
                      : '**** ${sSignalRModules.baseCurrency.symbol}',
                  revenueSum: store.isBalanceHide
                      ? marketFormat(
                          decimal: store.positionsTotalRevenueInVaseCurrency,
                          symbol: sSignalRModules.baseCurrency.symbol,
                          accuracy: 2,
                        )
                      : '**** ${sSignalRModules.baseCurrency.symbol}',
                ),
              ),
              SliverToBoxAdapter(
                child: EarnPositionsListWidget(
                  earnPositions: store.earnPositions,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: OffersListWidget(
                  filteredOffersGroupedByCurrency: store.filteredOffersGroupedByCurrency,
                  highestApyOffers: store.highestApyOffersPerCurrency,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          );
        },
      ),
    );
  }
}
