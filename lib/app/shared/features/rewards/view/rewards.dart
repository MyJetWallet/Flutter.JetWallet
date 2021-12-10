import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/set_banner_colors.dart';
import '../../market_details/helper/format_news_date.dart';
import '../../referral_stats/notifier/campaign_and_referral_notipod.dart';
import '../helper/create_reward_detail.dart';
import '../helper/set_reward_indicator_complete.dart';

class Rewards extends HookWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    final rewardsData = useProvider(campaignAndReferralNotipod);
    final rng = Random();

    return SPageFrameWithPadding(
      header: const SSmallHeader(
        title: 'Rewards',
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (final item in rewardsData.campaigns) ...[
                  if (item.conditions == null ||
                      (item.conditions != null &&
                          item.conditions!.isEmpty)) ...[
                    SRewardBanner(
                      color: setBannerColor(
                        rng.nextInt(3),
                        colors,
                      ),
                      primaryText: item.title,
                      secondaryText: item.description,
                      imageUrl: item.imageUrl,
                    ),
                  ],
                  if (item.conditions != null &&
                      item.conditions!.isNotEmpty) ...[
                    SThreeStepsRewardBanner(
                      primaryText: item.title,
                      timeToComplete: formatBannersDate(
                        item.timeToComplete,
                      ),
                      imageUrl: item.imageUrl,
                      circleAvatarColor: setBannerColor(
                        rng.nextInt(3),
                        colors,
                      ),
                      rewardDetail: createRewardDetail(
                        item.conditions!,
                      ),
                      rewardIndicatorComplete: setRewardIndicatorComplete(
                        item.conditions!,
                        colors,
                      ),
                    ),
                  ],
                ],
                for (final item in rewardsData.referralStats) ...[
                  const SpaceH20(),
                  SReferralStats(
                    referralInvited: item.referralInvited,
                    referralActivated: item.referralActivated,
                    bonusEarned: item.bonusEarned,
                    commissionEarned: item.commissionEarned,
                    total: item.total,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
