import 'package:flutter/material.dart';
import 'helper/create_banners_list.dart';
import 'helper/set_sized_banner_height.dart';

class SimpleAccountBannerList extends StatelessWidget {
  const SimpleAccountBannerList({
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
    final controller = PageController(viewportFraction: 0.88);

    final banners = createBannersList(
      twoFaEnabled: twoFaEnabled,
      kycPassed: kycPassed,
      phoneVerified: phoneVerified,
      onChatBannerTap: onChatBannerTap,
      onTwoFaBannerTap: onTwoFaBannerTap,
    );

    final pages = List.generate(
      banners.length,
      (index) => banners[index],
    );

    return SizedBox(
      height: setSizedBoxHeight(
        kycPassed: kycPassed,
        phoneVerified: phoneVerified,
        twoFaEnabled: twoFaEnabled,
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: banners.length,
              itemBuilder: (_, index) {
                return pages[index % banners.length];
              },
            ),
          ),
        ],
      ),
    );
  }
}
