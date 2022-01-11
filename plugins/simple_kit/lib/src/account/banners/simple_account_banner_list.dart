import 'package:flutter/material.dart';
import 'helper/create_banners_list.dart';

class SAccountBannerList extends StatelessWidget {
  const SAccountBannerList({
    Key? key,
    this.onTwoFaBannerTap,
    this.onChatBannerTap,
    required this.twoFaEnabled,
    required this.kycPassed,
    required this.phoneVerified,
  }) : super(key: key);

  final Function()? onTwoFaBannerTap;
  final Function()? onChatBannerTap;
  final bool twoFaEnabled;
  final bool kycPassed;
  final bool phoneVerified;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.9);

    final banners = createBannersList(
      twoFaEnabled: twoFaEnabled,
      kycPassed: kycPassed,
      phoneVerified: phoneVerified,
      onChatBannerTap: onChatBannerTap,
      onTwoFaBannerTap: onTwoFaBannerTap,
    );

    return SizedBox(
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
    );
  }

  double _bannerHeight() {
    if (!kycPassed || !phoneVerified) {
      return 171;
    } else if (!twoFaEnabled) {
      return 155;
    } else {
      return 129;
    }
  }
}
