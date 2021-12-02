import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/loaders/loader.dart';
import '../../market_details/helper/format_news_date.dart';
import '../notifier/campaign_notipod.dart';
import '../providers/campaign_fpod.dart';

class RewardsBanner extends HookWidget {
  const RewardsBanner({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final campaignsInit = useProvider(campaignsInitFpod);
    final campaign = useProvider(campaignNotipod);
    final campaignN = useProvider(campaignNotipod.notifier);
    final colors = useProvider(sColorPod);

    return campaignsInit.when(
      data: (data) {
        return SPageFrameWithPadding(
          header: SSmallHeader(
            title: 'Rewards',
            onBackButtonTap: () => Navigator.pop(context),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              if (data.campaigns[index].conditions != null) {
                return SThreeStepsRewardBanner(
                  primaryText: data.campaigns[index].title,
                  timeToComplete: formatBannersDate(
                    data.campaigns[index].timeToComplete,
                  ),
                  imageUrl: data.campaigns[index].imageUrl,
                );
              } else {
                return SRewardBannerExample(
                  bannerColor: colors.violet,
                  primaryText: data.campaigns[index].title,
                  secondaryText: data.campaigns[index].description,
                  imageUrl: data.campaigns[index].imageUrl,
                );
              }
            },
            itemCount: data.campaigns.length,
          ),
        );
      },
      loading: () => const Scaffold(body: Loader()),
      error: (_, __) => Scaffold(body: Container()),
    );
  }
}
