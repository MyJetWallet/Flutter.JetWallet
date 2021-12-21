import 'package:flutter/material.dart';

import '../../colors/view/simple_colors_light.dart';
import 'simple_account_banner.dart';

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
    final controller = PageController(viewportFraction: 0.85);

    final banners = createBannersList(
      twoFaEnabled: twoFaEnabled,
      kycPassed: kycPassed,
      phoneVerified: phoneVerified,
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

  double setSizedBoxHeight({
    required bool kycPassed,
    required bool phoneVerified,
    required bool twoFaEnabled,
  }) {
    if (!kycPassed || !phoneVerified) {
      return 171;
    } else if (!twoFaEnabled) {
      return 155;
    } else {
      return 129;
    }
  }

  List<Widget> createBannersList({
    required bool twoFaEnabled,
    required bool kycPassed,
    required bool phoneVerified,
  }) {
    final bannersList = <Widget>[];

    if (!kycPassed) {
      bannersList.add(
        SimpleAccountBanner(
          onTap: () {},
          color: SColorsLight().violet,
          header: 'Verify your profile',
          description: 'In accordance with KYC and AML Policy, '
              'you are required to pass the '
              'verification process.',
        ),
      );
    }

    if (!phoneVerified) {
      bannersList.add(
        SimpleAccountBanner(
          onTap: () {},
          color: SColorsLight().greenLight,
          header: 'Verifying now',
          description: 'You’ll be notified after we’ve completed the '
              'process. '
              'Usually within a few hours',
        ),
      );
    }

    if (!twoFaEnabled) {
      bannersList.add(
        SimpleAccountBanner(
          onTap: () {
            onTwoFaBannerTap?.call();
          },
          color: SColorsLight().redLight,
          header: 'Enable 2-Factor\nauthentication',
          description: 'To protect your account, it is recommended '
              'to turn on',
        ),
      );
    }

    bannersList.add(
      SimpleAccountBanner(
        onTap: () {
          onChatBannerTap?.call();
        },
        color: SColorsLight().yellowLight,
        header: 'Chat with support',
        description: 'Have any questions?\nWe here to help 24/7',
      ),
    );

    return bannersList;
  }
}
