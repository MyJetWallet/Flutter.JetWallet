import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';

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
  final intl = context.read(intlPod);
  final storage = context.read(localStorageServicePod);
  final userInfo = context.read(userInfoNotipod);
  final userInfoN = context.read(userInfoNotipod.notifier);
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

  if (showChatChecker != '3' && !userInfo.chatClosedOnThisSession) {
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
          userInfoN.updateChatClosed();
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
