import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/features/chart/store/chart_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/features/referral_program_gift/service/referral_gift_service.dart';
import 'package:jetwallet/features/rewards/store/reward_store.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/simple_kit.dart';


class PortfolioHeader extends StatelessObserverWidget {
  const PortfolioHeader({
    super.key,
    this.emptyBalance = false,
    this.price = '',
    this.showPrice = false,
  });

  final bool emptyBalance;
  final bool showPrice;
  final String price;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final viewedRewards = sSignalRModules.keyValue.viewedRewards?.value
        ?? <String>[];
    var counterOfRewards = 0;
    final rewStore = RewardStore();
    for (final campaign in rewStore.sortedCampaigns) {
      if (campaign.campaign != null &&
          !viewedRewards.contains(campaign.campaign!.campaignId)) {
        counterOfRewards++;
      }
    }
    if (!viewedRewards.contains('referral')) {
      counterOfRewards++;
    }

    final kycState = getIt.get<KycService>();

    ChartStore? chart;

    if (!emptyBalance) {
      chart = ChartStore.of(context) as ChartStore;
    }

    Color getContainerColor() {
      return (chart != null && chart.union != const ChartUnion.loading()) ||
              emptyBalance
          ? Colors.transparent
          : colors.grey5;
    }

    return Column(
      children: [
        const SpaceH54(),
        Row(
          children: [
            const SpaceW24(),
            Text(
              '${intl.portfolioHeader_balance}${showPrice ? ': $price' : ''}',
              style: sTextH5Style,
            ),
            const Spacer(),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SNotificationsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SNotificationsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {

                      sRouter.push(RewardsRouter(actualRewards: viewedRewards));
                    },
                  ),
                  NotificationBox(
                    notifications: counterOfRewards,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 56.0,
              height: 56.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SIconButton(
                    defaultIcon: SProfileDetailsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SProfileDetailsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sRouter.push(const AccountRouter());
                    },
                  ),
                  NotificationBox(
                    notifications: _profileNotificationLength(
                      KycModel(
                        depositStatus: kycState.depositStatus,
                        sellStatus: kycState.sellStatus,
                        withdrawalStatus: kycState.withdrawalStatus,
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                        verificationInProgress: kycState.verificationInProgress,
                      ),
                      true,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceW8(),
          ],
        ),
      ],
    );
  }

  int _profileNotificationLength(KycModel kycState, bool twoFaEnable) {
    var notificationLength = 0;

    final passed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );

    if (!passed) {
      notificationLength += 1;
    }

    if (!twoFaEnable) {
      notificationLength += 1;
    }

    return notificationLength;
  }
}
