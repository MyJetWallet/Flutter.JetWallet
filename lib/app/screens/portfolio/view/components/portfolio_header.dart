import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/features/chart/notifier/balance_chart_input_stpod.dart';
import '../../../../shared/features/chart/notifier/chart_notipod.dart';
import '../../../../shared/features/chart/notifier/chart_union.dart';
import '../../../../shared/features/referral_program_gift/provider/referral_gift_pod.dart';
import '../../../../shared/features/rewards/model/campaign_or_referral_model.dart';
import '../../../../shared/features/rewards/notifier/reward/rewards_notipod.dart';
import '../../../../shared/features/rewards/view/rewards.dart';

class PortfolioHeader extends HookWidget {
  const PortfolioHeader({
    Key? key,
    this.emptyBalance = false,
  }) : super(key: key);

  final bool emptyBalance;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final gift = useProvider(referralGiftPod);
    final state = useProvider(rewardsNotipod);
    final chart = useProvider(
      chartNotipod(
        useProvider(balanceChartInputStpod).state,
      ),
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
                  sAnalytics.rewardsScreenView(Source.giftIcon);
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
                        Container(
                          margin: (_giftBonus(state.sortedCampaigns).isNotEmpty)
                              ? const EdgeInsets.only(right: 8)
                              : EdgeInsets.zero,
                          child: Text(
                            _giftBonus(state.sortedCampaigns),
                            style: sSubtitle3Style.copyWith(
                              color: colors.white,
                            ),
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

  String _giftBonus(List<CampaignOrReferralModel> rewards) {
    var bonusGift = Decimal.zero;

    for (final item in rewards) {
      if (item.campaign?.conditions?.isNotEmpty ?? false) {
        for (final condition in item.campaign!.conditions!) {
          if (condition.reward != null) {
            bonusGift = bonusGift + condition.reward!.amount;
          }
        }
      }
    }

    if (bonusGift == Decimal.zero) {
      return '';
    } else {
      return '\$$bonusGift';
    }
  }
}
