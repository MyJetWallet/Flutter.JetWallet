import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/constants.dart';


List<Widget> createBannersList({
  Function()? onChatBannerTap,
  Function()? onTwoFaBannerTap,
  Function()? onKycBannerTap,
  required bool kycPassed,
  required bool twoFaEnabled,
  required bool phoneVerified,
  required bool verificationInProgress,
  required SimpleColors colors,
}) {
  final bannersList = <Widget>[];

  if (!verificationInProgress && !kycPassed) {
    bannersList.add(
      SimpleAccountBanner(
        onTap: () {
          onKycBannerTap?.call();
        },
        imageUrl: accountProfileAsset,
        color: colors.violet,
        header: 'Verify your profile',
        description: 'In accordance with KYC and AML Policy, '
            'you are required to pass the '
            'verification process.',
      ),
    );
  }

  if (verificationInProgress) {
    bannersList.add(
      SimpleAccountBanner(
        onTap: () {},
        color: colors.greenLight,
        header: 'Verifying now',
        imageUrl: verifyNowAsset,
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
        imageUrl: lockerAsset,
        color: colors.redLight,
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
      imageUrl: chatWithSupportAsset,
      color: colors.yellowLight,
      header: 'Chat with support',
      description: 'Have any questions?\nWe here to help 24/7',
    ),
  );

  return bannersList;
}
