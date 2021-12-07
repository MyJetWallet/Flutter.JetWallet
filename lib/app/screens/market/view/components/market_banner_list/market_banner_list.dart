import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/rewards/notifier/campaign_notipod.dart';
import '../../../../../shared/helpers/set_banner_colors.dart';
import '../../../provider/market_campaigns_pod.dart';

class MarketBannerList extends HookWidget {
  const MarketBannerList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useProvider(marketCampaignsPod);
    final campaign = useProvider(campaignNotipod(true));
    final campaignN = useProvider(campaignNotipod(true).notifier);
    final colors = useProvider(sColorPod);

    if (campaign.campaigns.isNotEmpty) {
      return SizedBox(
        height: 0.18.sh,
        child: ListView.builder(
          itemCount: campaign.campaigns.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
          itemBuilder: (BuildContext context, int index) => Container(
            padding: EdgeInsets.only(
              right: (index != campaign.campaigns.length - 1) ? 10.w : 0,
            ),
            child: SRewardBanner(
              bannerColor: setBannerColor(index, colors),
              primaryText: campaign.campaigns[index].title,
              imageUrl: campaign.campaigns[index].imageUrl,
              fontPrimaryText: sTextH5Style,
              onClose: () {
                campaignN.deleteCampaign(campaign.campaigns[index]);
              },
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
