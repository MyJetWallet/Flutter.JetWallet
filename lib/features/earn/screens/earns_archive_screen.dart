import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/widgets/navigation/top_app_bar/global_basic_appbar.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';

@RoutePage(name: 'EarnsArchiveRouter')
class EarnsArchiveScreen extends StatelessWidget {
  const EarnsArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      builder: (context, child) {
        final store = EarnStore.of(context);
        //! Alex S. fix this
        final earns = store.earnPositions;

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                GlobalBasicAppBar(
                  hasRightIcon: false,
                  title: intl.earn_earns_archive,
                ),
                if (earns.isEmpty)
                  SPlaceholder(
                    size: SPlaceholderSize.l,
                    text: intl.wallet_simple_account_empty,
                  ),
                ...earns
                    .map(
                      (e) => SDepositCard(earnPosition: e, onTap: () {}),
                    )
                    .toList(),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
