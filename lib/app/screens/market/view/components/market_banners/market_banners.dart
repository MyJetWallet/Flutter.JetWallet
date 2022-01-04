import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/constants.dart';
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
                        sShowAlertPopup(
                          context,
                          image: Image.asset(
                            verifyYourProfileAsset,
                          ),
                          primaryText: 'Verify your profile!',
                          secondaryText: 'To complete profile verification you '
                              'need to pass following steps:',
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: colors.grey4,
                                    ),
                                  ),
                                ),
                                height: 100,
                                child: Column(
                                  children: [
                                    Row(
                                      children: const [
                                        Baseline(
                                          baseline: 24.0,
                                          baselineType: TextBaseline.alphabetic,
                                          child: Text('1. Secure your account'),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Baseline(
                                          baseline: 24.0,
                                          baselineType: TextBaseline.alphabetic,
                                          child:
                                              Text('2. Verify your identity'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                child: Container(
                                  height: 23,
                                  width: 200,
                                  color: Colors.red.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                          primaryButtonName: 'Continue',
                          secondaryButtonName: 'Later',
                          onPrimaryButtonTap: () {},
                          onSecondaryButtonTap: () {
                            Navigator.pop(context);
                          },
                        );

                        // deepLinkService.handle(
                        //   Uri.parse(campaign.deepLink),
                        // );
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
