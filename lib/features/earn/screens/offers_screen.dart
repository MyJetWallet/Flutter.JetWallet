import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/core/simple_kit.dart';
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
        final offers = store.earnOffers;
        final colors = sKit.colors;

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  backgroundColor: colors.white,
                  pinned: true,
                  elevation: 0,
                  expandedHeight: 120,
                  collapsedHeight: 120,
                  primary: false,
                  flexibleSpace: GlobalBasicAppBar(
                    hasRightIcon: false,
                    title: intl.earn_all_offers,
                  ),
                ),
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: OffersListWidget(
                    showTitle: false,
                    earnOffers: offers,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.bottom),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
