import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_offers_list.dart';
import 'package:provider/provider.dart';
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

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                GlobalBasicAppBar(
                  hasRightIcon: false,
                  title: intl.earn_all_offers,
                ),
                OffersListWidget(
                  showTitle: false,
                  earnOffers: offers,
                ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
