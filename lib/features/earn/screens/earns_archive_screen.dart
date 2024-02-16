import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnsArchiveRouter')
class EarnsArchiveScreen extends StatelessWidget {
  const EarnsArchiveScreen({super.key, required this.earnPositionsClosed});
  final List<EarnPositionClientModel> earnPositionsClosed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlobalBasicAppBar(
              hasRightIcon: false,
              title: intl.earn_earns_archive,
            ),
            if (earnPositionsClosed.isEmpty)
              SPlaceholder(
                size: SPlaceholderSize.l,
                text: intl.wallet_simple_account_empty,
              ),
            ...earnPositionsClosed
                .map(
                  (e) => SDepositCard(earnPosition: e, onTap: () {}),
                )
                .toList(),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
