import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../shared/features/rewards/notifier/campaign/campaign_notipod.dart';
import '../../../../../shared/helpers/random_banner_color.dart';

class MarketBanners extends StatefulHookWidget {
  const MarketBanners({Key? key}) : super(key: key);

  @override
  State<MarketBanners> createState() => _MarketBannersState();
}

class _MarketBannersState extends State<MarketBanners> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(campaignNotipod(true));
    final notifier = useProvider(campaignNotipod(true).notifier);
    final colors = useProvider(sColorPod);
    final deepLinkService = useProvider(deepLinkServicePod);

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
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                        ),
                        child: SMarketBanner(
                          color: randomBannerColor(colors),
                          primaryText: campaign.title,
                          imageUrl: campaign.imageUrl,
                          primaryTextStyle: sTextH5Style,
                          onClose: () {
                            notifier.deleteCampaign(campaign);
                          },
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ),
        if (state.isNotEmpty) const SpaceH10(),
      ],
    );
  }
}
