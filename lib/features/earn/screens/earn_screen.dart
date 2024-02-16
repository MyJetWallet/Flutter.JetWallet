import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/basic_banner.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:jetwallet/features/earn/widgets/earn_positins_list.dart';
import 'package:jetwallet/features/earn/widgets/price_header.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

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
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        return _EarnView(controller: controller);
      },
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

    return Scaffold(
      body: NestedScrollView(
        controller: controller,
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              backgroundColor: colors.white,
              pinned: true,
              elevation: 0,
              expandedHeight: 120,
              collapsedHeight: 120,
              primary: false,
              flexibleSpace: FadeOnScroll(
                scrollController: controller,
                fullOpacityOffset: 50,
                fadeInWidget: const SDivider(
                  width: double.infinity,
                ),
                fadeOutWidget: const SizedBox.shrink(),
                permanentWidget: SMarketHeaderClosed(
                  title: intl.earn_earn,
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
          future: store.fetchClosedPositions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SBasicBanner(text: intl.earn_funds_are_calculated_based_on_the_current_value),
                ),
                if (store.earnPositions.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SPriceHeader(
                      totalSum: store.isBalanceHide
                          ? volumeFormat(
                              decimal: sSignalRModules.earnWalletProfileData?.total ?? Decimal.zero,
                              symbol: sSignalRModules.baseCurrency.symbol,
                            )
                          : '**** ${sSignalRModules.baseCurrency.symbol}',
                      revenueSum: store.isBalanceHide
                          ? volumeFormat(
                              decimal: sSignalRModules.earnWalletProfileData?.balance ?? Decimal.zero,
                              symbol: sSignalRModules.baseCurrency.symbol,
                            )
                          : '**** ${sSignalRModules.baseCurrency.symbol}',
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Observer(
                    builder: (context) {
                      return EarnPositionsListWidget(
                        earnPositions: store.earnPositions,
                        earnPositionsClosed: store.earnPositionsClosed,
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: OffersListWidget(earnOffers: store.earnOffers),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
