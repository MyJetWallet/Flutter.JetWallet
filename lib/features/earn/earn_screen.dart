import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/earn/store/earn_offers_store.dart';
import 'package:jetwallet/features/earn/widgets/earn_active_state/earn_active_state.dart';
import 'package:jetwallet/features/earn/widgets/earn_available_state/earn_available_state.dart';
import 'package:jetwallet/features/earn/widgets/earn_empty_state.dart';
import 'package:jetwallet/features/earn/widgets/earn_header.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../core/l10n/i10n.dart';

class EarnScreen extends StatelessWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EarnOffersStore>(
          create: (_) => EarnOffersStore(),
        ),
      ],
      builder: (context, child) {
        return const EarnScreenBody();
      },
    );
  }
}

class EarnScreenBody extends StatelessObserverWidget {
  const EarnScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final store = EarnOffersStore.of(context);
    final colors = sKit.colors;

    final isActive = store.isActiveState(store.earnOffers);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 120,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: const EarnHeader(),
          ),
          if (store.earnOffers.isEmpty) const EarnEmptyState(),
          if (!isActive && store.earnOffers.isNotEmpty)
            const EarnAvailableState(),
          if (isActive) const EarnActiveState(),
        ],
      ),
    );
  }
}
