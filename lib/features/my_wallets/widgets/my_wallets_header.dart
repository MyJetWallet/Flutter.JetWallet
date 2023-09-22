import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_kit/modules/bottom_navigation_bar/components/notification_box.dart';
import 'package:simple_kit/simple_kit.dart';

class MyWalletsHeader extends StatelessObserverWidget {
  const MyWalletsHeader({
    super.key,
    required this.isTitleCenter,
  });

  final bool isTitleCenter;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const _DefaultHeader(),
      secondChild: const _ScrollInProgressHeader(),
      crossFadeState:
          !isTitleCenter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration.zero,
    );
  }
}

class _DefaultHeader extends StatelessObserverWidget {
  const _DefaultHeader();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final kycState = getIt.get<KycService>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SpaceW24(),
        Text(
          intl.my_wallets_header,
          style: sTextH5Style,
        ),
        const SpaceW8(),
        SIconButton(
          defaultIcon: !getIt<AppStore>().isBalanceHide
              ? SEyeCloseIcon(
                  color: colors.black,
                )
              : SEyeOpenIcon(
                  color: colors.black,
                ),
          pressedIcon: !getIt<AppStore>().isBalanceHide
              ? SEyeCloseIcon(
                  color: colors.black.withOpacity(0.7),
                )
              : SEyeOpenIcon(
                  color: colors.black.withOpacity(0.7),
                ),
          onTap: () {
            if (getIt<AppStore>().isBalanceHide) {
              getIt<AppStore>().setIsBalanceHide(false);
            } else {
              getIt<AppStore>().setIsBalanceHide(true);
            }
          },
        ),
        const Spacer(),
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
              Row(
                children: [
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
                  const SpaceW8(),
                ],
              ),
            ],
          ),
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

class _ScrollInProgressHeader extends StatelessObserverWidget {
  const _ScrollInProgressHeader();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final kycState = getIt.get<KycService>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SpaceW56(),
        Text(
          'Wallets',
          style: sTextH5Style,
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
              Row(
                children: [
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
                  const SpaceW8(),
                ],
              ),
            ],
          ),
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
