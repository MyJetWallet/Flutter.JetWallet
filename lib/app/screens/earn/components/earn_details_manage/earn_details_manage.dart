import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/earn_offers_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'components/earn_details_manage_item.dart';

void showEarnDetailsManage({
  required BuildContext context,
  required EarnOfferModel earnOffer,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _EarnDetailsManageBottomSheetHeader(),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _EarnDetailsManage(earnOffer: earnOffer),
    ],
  );
}

class _EarnDetailsManageBottomSheetHeader extends HookWidget {
  const _EarnDetailsManageBottomSheetHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      children: [
        SPaddingH24(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 20.0,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  intl.earn_manage,
                  style: sTextH4Style,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SErasePressedIcon(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EarnDetailsManage extends HookWidget {
  const _EarnDetailsManage({
    Key? key,
    required this.earnOffer,
  }) : super(key: key);

  final EarnOfferModel earnOffer;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final intl = useProvider(intlPod);

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH24(),
            if (earnOffer.topUpEnabled)
              EarnDetailsManageItem(
                  primaryText: intl.earn_top_up,
                  onTap: () {},
                  icon: const STopUpIcon(),
                  color: colors.grey5,
              ),
            if (earnOffer.withdrawalEnabled && earnOffer.topUpEnabled)
              const SPaddingH24(child: SDivider()),
            if (earnOffer.withdrawalEnabled)
              EarnDetailsManageItem(
                  primaryText: intl.earn_return_to_wallet,
                  onTap: () {},
                  icon: const SForwardIcon(),
                  color: colors.grey5,
              ),
            const SpaceH24(),
          ],
        ),
      ],
    );
  }
}
