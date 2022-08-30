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
  required bool twoFaEnabled,
  required bool phoneVerified,
  required bool verificationInProgress,
  required SimpleColors colors,
  required BuildContext context,
}) {
  final storage = sLocalStorageService;
  final userInfo = sUserInfo;
  final bannersList = <Widget>[];

  if (!verificationInProgress && !kycPassed) {
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
        header: '${intl.createBanners_enable2Factor}\n'
            '${intl.createBanners_authentication}',
        description: intl.createBanners_bannerText3,
      ),
    );
  }

  if (showChatChecker != '3' && !userInfo.userInfo.chatClosedOnThisSession) {
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
        canClose: true,
        onClose: () async {
          sAnalytics.bannerClose(bannerName: 'Chat with support');
          final closed = await storage.getValue(closedSupportBannerKey);
          userInfo.updateChatClosed();
          var closedCounter = 1;
          if (closed != null) {
            closedCounter = int.parse(closed) + 1;
          }
          await storage.setString(closedSupportBannerKey, '$closedCounter');
        },
      ),
    );
  }

  return bannersList;
}
