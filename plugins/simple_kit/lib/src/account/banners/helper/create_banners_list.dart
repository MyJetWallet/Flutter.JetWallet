import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_light.dart';
import '../simple_account_banner.dart';

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
