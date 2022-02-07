import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/features/chart/notifier/chart_notipod.dart';
import '../../../../../shared/features/chart/notifier/chart_union.dart';
import '../../../../../shared/features/referral_program_gift/provider/referral_gift_pod.dart';
import '../../../../../shared/features/rewards/view/rewards.dart';

class PortfolioWithBalanceHeader extends HookWidget {
  const PortfolioWithBalanceHeader({
    Key? key,
    this.emptyBalance = false,
  }) : super(key: key);

  final bool emptyBalance;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final gift = useProvider(referralGiftPod);
    final chart = useProvider(
      chartNotipod,
    );

    return Container(
      height: 120,
      color: chart.union != const ChartUnion.loading() || emptyBalance
          ? Colors.transparent
          : colors.grey5,
      child: Column(
        children: [
          const SpaceH64(),
          Row(
            children: [
              const SpaceW24(),
              Text(
                'Balance',
                style: sTextH5Style,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  navigatorPush(context, const Rewards());
                },
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: colors.green,
                  ),
                  child: Row(
                    children: [
                      const SGiftPortfolioIcon(),
                      if (gift == ReferralGiftStatus.showGift) ...[
                        const SpaceW8(),
                        Text(
                          '\$15',
                          style: sSubtitle3Style.copyWith(
                            color: colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SpaceW24(),
            ],
          ),
        ],
      ),
    );
  }
}
