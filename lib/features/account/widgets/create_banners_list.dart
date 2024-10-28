import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_kit/simple_kit.dart';

import 'account_status_banner.dart';

List<Widget> createBannersList({
  Function()? onChatBannerTap,
  Function()? onTwoFaBannerTap,
  Function()? onKycBannerTap,
  String? showChatChecker,
  required bool kycRequired,
  required bool kycBlocked,
  required bool twoFaEnabled,
  required bool phoneVerified,
  required bool verificationInProgress,
  required SimpleColors colors,
}) {
  final bannersList = <Widget>[];

  if (!verificationInProgress && kycRequired && !kycBlocked) {
    bannersList.add(
      AccountStatusBanner(
        icon: const SAccountVerifyIcon(),
        title: intl.createBannersList_verifyYourProfile,
        onTap: () {
          onKycBannerTap?.call();
        },
        mainColor: colors.blueLight,
        textColor: colors.blue,
      ),
    );
  }

  if (verificationInProgress && !kycBlocked) {
    bannersList.add(
      AccountStatusBanner(
        icon: const SAccountWaitingIcon(),
        title: '${intl.createBanners_header2}...',
        onTap: () {
          onKycBannerTap?.call();
        },
        mainColor: colors.yellowLight,
        textColor: colors.orange,
      ),
    );
  }

  if (kycBlocked) {
    bannersList.add(
      AccountStatusBanner(
        icon: const SAccountBlockedIcon(),
        title: intl.createBanners_headerBlocked,
        onTap: () {
          onKycBannerTap?.call();
        },
        mainColor: colors.redLight,
        textColor: colors.red,
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
        header: '${intl.createBanners_enable2Factor}\n'
            '${intl.createBanners_authentication}',
        description: intl.createBanners_bannerText3,
      ),
    );
  }

  return bannersList;
}
