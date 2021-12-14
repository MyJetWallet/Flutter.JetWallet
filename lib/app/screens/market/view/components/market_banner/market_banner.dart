import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../shared/features/rewards/notifier/campaign_notipod.dart';
import '../../../../../shared/helpers/set_banner_colors.dart';

class MarketBanner extends HookWidget {
  const MarketBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaign = useProvider(campaignNotipod(true));
    final campaignN = useProvider(campaignNotipod(true).notifier);
    final colors = useProvider(sColorPod);
    final deepLinkService = useProvider(deepLinkServicePod);

    if (campaign.isNotEmpty) {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          itemCount: campaign.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 10,
          ),
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              deepLinkService.handle(Uri.parse(campaign[index].deepLink));
            },
            child: Container(
              padding: EdgeInsets.only(
                right: (index != campaign.length - 1) ? 10 : 0,
              ),
              child: SRewardBanner(
                color: setBannerColor(index, colors),
                primaryText: campaign[index].title,
                imageUrl: campaign[index].imageUrl,
                primaryTextStyle: sTextH5Style,
                onClose: () {
                  campaignN.deleteCampaign(campaign[index]);
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
