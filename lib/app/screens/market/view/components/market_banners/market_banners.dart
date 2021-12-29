import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../shared/features/rewards/notifier/campaign/campaign_notipod.dart';
import '../../../../../shared/helpers/random_banner_color.dart';

class MarketBanners extends HookWidget {
  const MarketBanners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(campaignNotipod(true));
    final notifier = useProvider(campaignNotipod(true).notifier);
    final colors = useProvider(sColorPod);
    final deepLinkService = useProvider(deepLinkServicePod);

    final controller = PageController(viewportFraction: 0.92);

    if (state.isNotEmpty) {
      return SizedBox(
        height: 120,
        child: PageView.builder(
          controller: controller,
          itemCount: state.length,
          itemBuilder: (_, index) {
            final campaign = state[index];

            return GestureDetector(
              onTap: () {
                deepLinkService.handle(
                  Uri.parse(campaign.deepLink),
                );
              },
              child: SRewardBanner(
                color: randomBannerColor(colors),
                primaryText: campaign.title,
                imageUrl: campaign.imageUrl,
                primaryTextStyle: sTextH5Style,
                onClose: () {
                  notifier.deleteCampaign(campaign);
                },
                indentRight: state.length == 1,
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
