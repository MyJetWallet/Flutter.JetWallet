import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

List<Widget> createBannersList({
  Function()? onChatBannerTap,
  Function()? onTwoFaBannerTap,
  Function()? onKycBannerTap,
  String? showChatChecker,
  required bool kycPassed,
  required bool kycBlocked,
  required bool twoFaEnabled,
  required bool phoneVerified,
  required bool verificationInProgress,
  required SimpleColors colors,
  required BuildContext context,
}) {
  final storage = sLocalStorageService;
  final userInfo = sUserInfo;
  final bannersList = <Widget>[];

  if (!verificationInProgress && !kycPassed && !kycBlocked) {
    bannersList.add(
      SimpleAccountBanner(
        onTap: () {
          onKycBannerTap?.call();
        },
        imageUrl: accountProfileAsset,
        color: colors.greenLight,
        header: intl.createBannersList_verifyYourProfile,
        description: intl.createBanners_bannerText1,
      ),
    );
  }

  if (verificationInProgress && !kycBlocked) {
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

  if (kycBlocked) {
    bannersList.add(
      SimpleAccountBanner(
        onTap: () {
          onKycBannerTap?.call();
        },
        color: colors.redLight,
        header: '${intl.kycAlertHandler_youAreBlocked}!',
        imageUrl: blockedAsset,
        description: '${intl.kycAlertHandler_showBlockedAlertSecondaryText1} '
            '${intl.kycAlertHandler_showBlockedAlertSecondaryText2}',
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
