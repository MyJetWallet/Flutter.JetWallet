import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/providers/service_providers.dart';

List<Widget> createBannersList({
  Function()? onChatBannerTap,
  Function()? onTwoFaBannerTap,
  Function()? onKycBannerTap,
  required bool kycPassed,
  required bool twoFaEnabled,
  required bool phoneVerified,
  required bool verificationInProgress,
  required SimpleColors colors,
  required BuildContext context,
}) {
  final intl = context.read(intlPod);
  final bannersList = <Widget>[];

  if (!verificationInProgress && !kycPassed) {
    bannersList.add(
      SimpleAccountBanner(
        onTap: () {
          onKycBannerTap?.call();
        },
        imageUrl: accountProfileAsset,
        color: colors.greenLight,
        header: intl.verifyYourProfile,
        description: intl.createBanners_bannerText1,
      ),
    );
  }

  if (verificationInProgress) {
    bannersList.add(
      SimpleAccountBanner(
        onTap: () {
          onKycBannerTap?.call();
        },
        color: colors.greenLight,
        header: intl.createBanners_header2,
        imageUrl: verifyNowAsset,
        description: intl.createBanners_bannerText2,
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
        color: colors.blueLight,
        header: '${intl.createBanners_enable2Factor}\n${intl.authentication}',
        description: intl.createBanners_bannerText3,
      ),
    );
  }

  bannersList.add(
    SimpleAccountBanner(
      onTap: () {
        onChatBannerTap?.call();
      },
      imageUrl: chatWithSupportAsset,
      color: colors.violet,
      header: intl.createBanners_header4,
      description: '${intl.createBanners_bannerText4Part1}?\n'
          '${intl.createBanners_bannerText4Part2}',
    ),
  );

  return bannersList;
}
