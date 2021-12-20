import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/set_banner_colors.dart';
import '../../market_details/helper/format_news_date.dart';
import '../helper/create_reward_detail.dart';
import '../helper/set_reward_indicator_complete.dart';
import '../model/combined_reward_model.dart';
import '../notifier/rewards_notipod.dart';

const maxRandomNumber = 3;

class Rewards extends HookWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final rewards = useProvider(rewardsNotipod);
    final randomNumber = Random();

    return SPageFrameWithPadding(
      header: const SSmallHeader(
        title: 'Rewards',
      ),
      child: ListView(
        children: [
          for (final item in rewards) ...[
            if (item.conditions != null)
              if (item.conditions!.isNotEmpty)
                if (_displaySThreeStepsRewardBanner(item))
                  SThreeStepsRewardBanner(
                    primaryText: item.title!,
                    timeToComplete: formatBannersDate(
                      item.timeToComplete!,
                    ),
                    imageUrl: item.imageUrl,
                    circleAvatarColor: setBannerColor(
                      randomNumber.nextInt(maxRandomNumber),
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
            if (_displaySRewardBanner(item))
              SRewardBanner(
                color: setBannerColor(
                  randomNumber.nextInt(maxRandomNumber),
                  colors,
                ),
                primaryText: item.title!,
                secondaryText: item.description,
                imageUrl: item.imageUrl,
              ),
            if (_displaySReferralStats(item))
              SReferralStats(
                referralInvited: item.referralInvited!,
                referralActivated: item.referralActivated!,
                bonusEarned: item.bonusEarned!,
                commissionEarned: item.commissionEarned!,
                total: item.total!,
              ),
          ],
        ],
      ),
    );
  }

  bool _displaySThreeStepsRewardBanner(CombinedRewardModel item) {
    return item.conditions != null ||
        (item.conditions != null && item.conditions!.isNotEmpty);
  }

  bool _displaySRewardBanner(CombinedRewardModel item) {
    return item.conditions == null ||
        (item.conditions != null && item.conditions!.isEmpty);
  }

  bool _displaySReferralStats(CombinedRewardModel item) {
    return item.total != null;
  }
}
