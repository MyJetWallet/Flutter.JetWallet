import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'create_banners_list.dart';

class AccountBannerList extends HookWidget {
  const AccountBannerList({
    Key? key,
    this.onTwoFaBannerTap,
    this.onChatBannerTap,
    this.onKycBannerTap,
    required this.kycPassed,
    required this.twoFaEnabled,
    required this.phoneVerified,
    required this.verificationInProgress,
  }) : super(key: key);

  final Function()? onTwoFaBannerTap;
  final Function()? onChatBannerTap;
  final Function()? onKycBannerTap;
  final bool kycPassed;
  final bool twoFaEnabled;
  final bool phoneVerified;
  final bool verificationInProgress;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.9);
    final colors = useProvider(sColorPod);

    final banners = createBannersList(
      kycPassed: kycPassed,
      verificationInProgress: verificationInProgress,
      twoFaEnabled: twoFaEnabled,
      phoneVerified: phoneVerified,
      onChatBannerTap: onChatBannerTap,
      onTwoFaBannerTap: onTwoFaBannerTap,
      onKycBannerTap: onKycBannerTap,
      colors: colors,
      context: context,
    );

    return Column(
      children: [
        SizedBox(
          height: _bannerHeight(),
          child: PageView.builder(
            controller: controller,
            itemCount: banners.length,
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                ),
                child: banners[index],
              );
            },
          ),
        ),
        if (banners.length > 1)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SmoothPageIndicator(
                controller: controller,
                count: banners.length,
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
      ],
    );
  }

  double _bannerHeight() {
    if (verificationInProgress || !kycPassed) {
      return 171;
    } else if (!twoFaEnabled) {
      return 155;
    } else {
      return 129;
    }
  }
}
