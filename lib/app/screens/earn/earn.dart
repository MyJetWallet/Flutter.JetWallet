import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../shared/features/earn/notifier/earn_offers_notipod.dart';
import '../../shared/features/earn/provider/earn_offers_pod.dart';
import 'components/earn_active_state/earn_active_state.dart';
import 'components/earn_available_state/earn_available_state.dart';
import 'components/earn_empty_state.dart';
import 'components/earn_header.dart';

class Earn extends HookWidget {
  const Earn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final earnOffers = useProvider(earnOffersPod);
    final notifier = useProvider(earnOffersNotipod.notifier);
    final colors = useProvider(sColorPod);

    final isActive = earnOffers.isNotEmpty &&
        notifier.isActiveState(earnOffers);

    return SPageFrame(
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
          if (!isActive) const EarnAvailableState(),
          if (earnOffers.isEmpty) const EarnEmptyState(),
          if (isActive) const EarnActiveState(),
        ],
      ),
    );
  }
}
