import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../../shared/services/deep_link_service.dart';
import '../../../../../shared/features/rewards/notifier/campaign/campaign_notipod.dart';

const bannersColor = [
  Color(0xFFE0E3FA),
  Color(0xFFE8F9E8),
  Color(0xFFD5F4F4),
  Color(0xFFFAF3E0),
];

class MarketBanners extends HookWidget {
  const MarketBanners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(campaignNotipod(true));
    final notifier = useProvider(campaignNotipod(true).notifier);
    final deepLinkService = useProvider(deepLinkServicePod);
    final colors = useProvider(sColorPod);

    final controller = PageController(viewportFraction: 0.9);

    return Column(
      children: [
        AnimatedContainer(
          duration: (state.isNotEmpty)
              ? Duration.zero
              : const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          height: state.isNotEmpty ? 120.0 : 0.0,
          child: (state.isNotEmpty)
              ? PageView.builder(
                  controller: controller,
                  itemCount: state.length,
                  itemBuilder: (_, index) {
                    final campaign = state[index];

                    return GestureDetector(
                      onTap: () {
                        deepLinkService.handle(
                          Uri.parse(campaign.deepLink),
                          SourceScreen.bannerOnMarket,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                        ),
                        child: SMarketBanner(
                          color: bannersColor[index],
                          primaryText: campaign.title,
                          imageUrl: campaign.imageUrl,
                          primaryTextStyle: sTextH5Style,
                          onClose: () {
                            sAnalytics.clickMarketBanner(
                              campaign.title,
                              MarketBannerAction.close,
                            );
                            notifier.deleteCampaign(campaign);
                          },
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SmoothPageIndicator(
              controller: controller,
              count: state.length,
              effect: ScrollingDotsEffect(
                spacing: 2,
                radius: 4,
                dotWidth: 8,
                dotHeight: 2,
                maxVisibleDots: 11,
                activeDotScale: 1,
                dotColor: colors.black.withOpacity(0.1),
                activeDotColor: colors.black,
              ),
            ),
          ),
        ),
        if (state.isNotEmpty) const SpaceH10(),
      ],
    );
  }
}
