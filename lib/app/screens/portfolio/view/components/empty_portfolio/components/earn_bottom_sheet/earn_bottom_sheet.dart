import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/models/currency_model.dart';
import '../../../../../../market/view/components/fade_on_scroll.dart';
import 'components/earn_body.dart';
import 'components/earn_pinned.dart';
import 'components/earn_pinned_small.dart';

void showStartEarnBottomSheet({
  required BuildContext context,
  required Function(CurrencyModel) onTap,
}) {
  final controller = useScrollController();
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    removeBottomSheetBar: true,
    removeBarPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    pinned: SliverAppBar(
      pinned: true,
      elevation: 0,
      expandedHeight: 160,
      collapsedHeight: 120,
      primary: false,
      flexibleSpace: FadeOnScroll(
        scrollController: controller,
        fullOpacityOffset: 50,
        fadeInWidget: const Text('123'),
        fadeOutWidget: const Text('123324'),
        permanentWidget: const SMarketHeaderClosed(
          title: 'Market',
        ),
      ),
    ),
    children: [
      EarnBody(
        onTap: onTap,
      ),
    ],
  );
}
