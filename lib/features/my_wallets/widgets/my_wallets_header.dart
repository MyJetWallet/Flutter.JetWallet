import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class MyWalletsHeader extends StatefulWidget {
  const MyWalletsHeader({
    super.key,
    required this.isTitleCenter,
  });

  final bool isTitleCenter;

  @override
  State<MyWalletsHeader> createState() => _MyWalletsHeaderState();
}

class _MyWalletsHeaderState extends State<MyWalletsHeader> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.white,
      child: AnimatedCrossFade(
        firstChild: const _DefaultHeader(),
        secondChild: const _ScrollInProgressHeader(),
        crossFadeState: !widget.isTitleCenter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }
}

class _DefaultHeader extends StatelessObserverWidget {
  const _DefaultHeader();

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final kycState = getIt.get<KycService>();

    final notificationsCount = _profileNotificationLength(
      KycModel(
        depositStatus: kycState.depositStatus,
        sellStatus: kycState.tradeStatus,
        withdrawalStatus: kycState.withdrawalStatus,
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        verificationInProgress: kycState.verificationInProgress,
      ),
      true,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceW24(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                intl.my_wallets_header,
                style: sTextH4Style,
              ),
            ),
            const SpaceW8(),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SIconButton(
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
                  sAnalytics.tapOnTheButtonShowHideBalancesOnWalletsScreen(
                    isShowNow: !getIt<AppStore>().isBalanceHide,
                  );
                },
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            sAnalytics.tapOnTheButtonProfileOnWalletsScreen();
            final myWalletsSrore = getIt.get<MyWalletsSrore>();
            if (myWalletsSrore.isReordering) {
              myWalletsSrore.endReorderingImmediately();
            } else {
              sRouter.push(const AccountRouter());
            }
          },
          child: SizedBox(
            height: 49,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SIconButton(
                      defaultIcon: SProfileDetailsIcon(
                        color: colors.black,
                      ),
                      pressedIcon: SProfileDetailsIcon(
                        color: colors.black.withOpacity(0.7),
                      ),
                      onTap: () {
                        sAnalytics.tapOnTheButtonProfileOnWalletsScreen();
                        final myWalletsSrore = getIt.get<MyWalletsSrore>();
                        if (myWalletsSrore.isReordering) {
                          myWalletsSrore.endReorderingImmediately();
                        } else {
                          sRouter.push(const AccountRouter());
                        }
                      },
                    ),
                    const SpaceW24(),
                  ],
                ),
                if (notificationsCount != 0)
                  Positioned(
                    right: 17,
                    top: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: ShapeDecoration(
                        color: colors.purple,
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: colors.white,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          notificationsCount.toString(),
                          textAlign: TextAlign.center,
                          style: sTextButtonStyle.copyWith(
                            color: colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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

    final notificationsCount = _profileNotificationLength(
      KycModel(
        depositStatus: kycState.depositStatus,
        sellStatus: kycState.tradeStatus,
        withdrawalStatus: kycState.withdrawalStatus,
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        verificationInProgress: kycState.verificationInProgress,
      ),
      true,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 64,
          width: 48,
        ),
        Column(
          children: [
            const SpaceH10(),
            Text(
              intl.my_wallets_header,
              style: sTextH5Style,
            ),
          ],
        ),
        SizedBox(
          height: 47,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SIconButton(
                    defaultIcon: SProfileDetailsIcon(
                      color: colors.black,
                    ),
                    pressedIcon: SProfileDetailsIcon(
                      color: colors.black.withOpacity(0.7),
                    ),
                    onTap: () {
                      sAnalytics.tapOnTheButtonProfileOnWalletsScreen();
                      final myWalletsSrore = getIt.get<MyWalletsSrore>();
                      if (myWalletsSrore.isReordering) {
                        myWalletsSrore.endReorderingImmediately();
                      } else {
                        sRouter.push(const AccountRouter());
                      }
                    },
                  ),
                  const SpaceW24(),
                ],
              ),
              if (notificationsCount != 0)
                Positioned(
                  right: 17,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: ShapeDecoration(
                      color: colors.purple,
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 3,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: colors.white,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        notificationsCount.toString(),
                        textAlign: TextAlign.center,
                        style: sTextButtonStyle.copyWith(
                          color: colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
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
