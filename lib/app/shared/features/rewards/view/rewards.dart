import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/set_banner_colors.dart';
import '../../market_details/helper/format_news_date.dart';
import '../helper/create_reward_detail.dart';
import '../helper/set_reward_indicator_complete.dart';
import '../notifier/campaign_notipod.dart';

class Rewards extends HookWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaign = useProvider(campaignNotipod(false));
    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      header: const SSmallHeader(
        title: 'Rewards',
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              if (index == 0) const SpaceH20(),
              if (campaign.campaigns[index].conditions == null) ...[
                SRewardBanner(
                  color: setBannerColor(index, colors),
                  primaryText: campaign.campaigns[index].title,
                  secondaryText: campaign.campaigns[index].description,
                  imageUrl: campaign.campaigns[index].imageUrl,
                ),
              ],
              if (campaign.campaigns[index].conditions != null) ...[
                SThreeStepsRewardBanner(
                  primaryText: campaign.campaigns[index].title,
                  timeToComplete: formatBannersDate(
                    campaign.campaigns[index].timeToComplete,
                  ),
                  imageUrl: campaign.campaigns[index].imageUrl,
                  circleAvatarColor: setBannerColor(index, colors),
                  rewardDetail: createRewardDetail(
                    campaign.campaigns[index].conditions!,
                  ),
                  rewardIndicatorComplete: setRewardIndicatorComplete(
                    campaign.campaigns[index].conditions!,
                    colors,
                  ),
                ),
              ],
            ],
          );
        },
        itemCount: campaign.campaigns.length,
      ),
    );
  }
}
