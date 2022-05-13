import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../shared/features/earn/provider/earn_offers_pod.dart';
import 'components/earn_empty_state.dart';
import 'components/earn_header.dart';
import 'components/earn_items/earn_items.dart';

class Earn extends HookWidget {
  const Earn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final earnOffers = useProvider(earnOffersPod);
    final colors = useProvider(sColorPod);

    return SPageFrame(
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: earnOffers.isNotEmpty ? 160 : 120,
            collapsedHeight: earnOffers.isNotEmpty ? 160 : 120,
            primary: false,
            flexibleSpace: const EarnHeader(),
          ),
          if (earnOffers.isNotEmpty)
            const EarnItems(),
          if (earnOffers.isEmpty)
            const EarnEmptyState(),
        ],
      ),
    );
  }
}
