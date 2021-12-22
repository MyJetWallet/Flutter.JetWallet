import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../shared/features/rewards/notifier/campaign_notipod.dart';
import '../../../../../shared/helpers/set_banner_colors.dart';

class MarketBanner extends HookWidget {
  const MarketBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaign = useProvider(campaignNotipod(true));
    final campaignN = useProvider(campaignNotipod(true).notifier);
    final colors = useProvider(sColorPod);
    final deepLinkService = useProvider(deepLinkServicePod);

    final controller = PageController(viewportFraction: 0.88);

    final banners = _createMarketBannersList(
      campaign,
      colors,
      (CampaignModel campaignItem) {
        campaignN.deleteCampaign(campaignItem);
      },
      (CampaignModel campaign) {
        deepLinkService.handle(Uri.parse(campaign.deepLink));
      },
    );

    final pages = List.generate(
      banners.length,
      (index) => banners[index],
    );

    return AnimatedContainer(
      duration: (campaign.isNotEmpty)
          ? Duration.zero
          : const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      height: campaign.isNotEmpty ? 120.0 : 0.0,
      child: (campaign.isNotEmpty)
          ? PageView.builder(
              controller: controller,
              itemCount: banners.length,
              itemBuilder: (_, index) {
                return pages[index % banners.length];
              },
            )
          : const SizedBox(),
    );
  }

  List<Widget> _createMarketBannersList(
    List<CampaignModel> campaigns,
    SimpleColors colors,
    Function(CampaignModel campaign) onClose,
    Function(CampaignModel campaign) onBannerTap,
  ) {
    final bannersList = <Widget>[];

    for (var index = 0; index < campaigns.length; index++) {
      bannersList.add(
        GestureDetector(
          onTap: () => onBannerTap(campaigns[index]),
          child: SRewardBanner(
            color: setBannerColor(index, colors),
            primaryText: campaigns[index].title,
            imageUrl: campaigns[index].imageUrl,
            primaryTextStyle: sTextH5Style,
            onClose: () => onClose(campaigns[index]),
            indentRight: campaigns.length == 1,
          ),
        ),
      );
    }

    return bannersList;
  }
}
