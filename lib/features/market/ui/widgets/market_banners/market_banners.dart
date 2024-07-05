import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/features/rewards/store/reward_campaign_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const bannersColor = [
  Color(0xFFE0E3FA),
  Color(0xFFD5F4F4),
  Color(0xFFE0EBFA),
  Color(0xFFFAF3E0),
];

class MarketBanners extends StatelessWidget {
  const MarketBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RewardCampaignStore>(
      create: (context) => RewardCampaignStore(true),
      builder: (context, child) => const _MarketBannersBody(),
    );
  }
}

class _MarketBannersBody extends StatelessObserverWidget {
  const _MarketBannersBody();

  @override
  Widget build(BuildContext context) {
    final store = RewardCampaignStore.of(context);

    final deepLinkService = getIt.get<DeepLinkService>();
    final colors = sKit.colors;

    final controller = PageController(viewportFraction: 0.9);

    return Column(
      children: [
        AnimatedContainer(
          duration: (store.campaigns.isNotEmpty) ? Duration.zero : const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          height: store.campaigns.isNotEmpty ? 120.0 : 0.0,
          child: (store.campaigns.isNotEmpty)
              ? PageView.builder(
                  controller: controller,
                  itemCount: store.campaigns.length,
                  itemBuilder: (_, index) {
                    final campaign = store.campaigns[index];

                    return GestureDetector(
                      onTap: () {
                        deepLinkService.handle(
                          Uri.parse(campaign.deepLink),
                          source: SourceScreen.bannerOnMarket,
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
                            store.deleteCampaign(campaign);
                          },
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ),
        if (store.campaigns.length > 1)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SmoothPageIndicator(
                controller: controller,
                count: store.campaigns.length,
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
        if (store.campaigns.isNotEmpty) const SpaceH10(),
      ],
    );
  }
}
