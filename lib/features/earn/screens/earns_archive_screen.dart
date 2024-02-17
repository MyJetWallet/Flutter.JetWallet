import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnsArchiveRouter')
class EarnsArchiveScreen extends StatelessWidget {
  const EarnsArchiveScreen({super.key, required this.earnPositionsClosed});
  final List<EarnPositionClientModel> earnPositionsClosed;

  @override
  Widget build(BuildContext context) {
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
                title: intl.earn_earns_archive,
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            if (earnPositionsClosed.isEmpty)
              SliverFillRemaining(
                child: SPlaceholder(
                  size: SPlaceholderSize.l,
                  text: intl.wallet_simple_account_empty,
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SDepositCard(
                    earnPosition: earnPositionsClosed[index],
                    onTap: () {},
                  );
                },
                childCount: earnPositionsClosed.length,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
          ],
        ),
      ),
    );
  }
}
