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
              if (campaign[index].conditions == null ||
                  (campaign[index].conditions != null &&
                      campaign[index].conditions!.isEmpty)) ...[
                SRewardBanner(
                  color: setBannerColor(index, colors),
                  primaryText: campaign[index].title,
                  secondaryText: campaign[index].description,
                  imageUrl: campaign[index].imageUrl,
                ),
              ],
              if (campaign[index].conditions != null &&
                  campaign[index].conditions!.isNotEmpty) ...[
                SThreeStepsRewardBanner(
                  primaryText: campaign[index].title,
                  timeToComplete: formatBannersDate(
                    campaign[index].timeToComplete,
                  ),
                  imageUrl: campaign[index].imageUrl,
                  circleAvatarColor: setBannerColor(index, colors),
                  rewardDetail: createRewardDetail(
                    campaign[index].conditions!,
                  ),
                  rewardIndicatorComplete: setRewardIndicatorComplete(
                    campaign[index].conditions!,
                    colors,
                  ),
                ),
              ],
            ],
          );
        },
        itemCount: campaign.length,
      ),
    );
  }
}
