import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_deposit/action_deposit.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_sell/action_sell.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/action_withdraw/action_withdraw.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/kyc/models/kyc_verified_model.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/localized_action_items.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class BottomNavigationMenu extends StatefulObserverWidget {
  const BottomNavigationMenu({
    Key? key,
    required this.transitionAnimationController,
    required this.currentIndex,
    required this.onChanged,
  }) : super(key: key);

  final AnimationController transitionAnimationController;
  final int currentIndex;
  final Function(int) onChanged;

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    void updateActionState() {
      getIt.get<AppStore>().setActionMenuActive(
            !getIt.get<AppStore>().actionMenuActive,
          );
    }

    final isNotEmptyBalance = !areBalancesEmpty(sSignalRModules.currenciesList);
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getIt.get<AppStore>().openBottomMenu) {
        _openBottomMenu(
          context,
          isNotEmptyBalance,
          KycModel(
            depositStatus: kycState.depositStatus,
            sellStatus: kycState.sellStatus,
            withdrawalStatus: kycState.withdrawalStatus,
            requiredDocuments: kycState.requiredDocuments,
            requiredVerifications: kycState.requiredVerifications,
            verificationInProgress: kycState.verificationInProgress,
          ),
          kycAlertHandler,
          updateActionState,
        );
        updateActionState();

        getIt.get<AppStore>().setOpenBottomMenu(false);
      }
    });

    return SBottomNavigationBar(
      profileNotifications: _profileNotificationLength(
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
      //cardNotifications: bottomMenuNotifier.cardNotification,
      cardNotifications: false,
      selectedIndex: widget.currentIndex,
      actionActive: getIt.get<AppStore>().actionMenuActive,
      earnEnabled: sSignalRModules.earnProfile?.earnEnabled ?? false,
      animationController: widget.transitionAnimationController,
      onActionTap: () {
        _openBottomMenu(
          context,
          isNotEmptyBalance,
          KycModel(
            depositStatus: kycState.depositStatus,
            sellStatus: kycState.sellStatus,
            withdrawalStatus: kycState.withdrawalStatus,
            requiredDocuments: kycState.requiredDocuments,
            requiredVerifications: kycState.requiredVerifications,
            verificationInProgress: kycState.verificationInProgress,
          ),
          kycAlertHandler,
          updateActionState,
        );
        updateActionState();
      },
      onChanged: widget.onChanged,
    );
  }

  // ignore: long-parameter-list
  void _openBottomMenu(
    BuildContext context,
    bool isNotEmptyBalance,
    KycModel kycState,
    KycAlertHandler kycAlertHandler,
    Function() updateActionState,
  ) {
    if (!getIt.get<AppStore>().actionMenuActive) {
      sShowMenuActionSheet(
        context: context,
        isNotEmptyBalance: isNotEmptyBalance,
        isBuyAvailable: false,
        onBuy: () {
          sAnalytics.tapOnBuy(Source.quickActions);

          showBuyAction(
            context: context,
            fromCard: false,
          );
        },
        onBuyFromCard: () {
          sAnalytics.tapOnBuyFromCard(Source.quickActions);

          showBuyAction(
            context: context,
            fromCard: true,
          );
        },
        isSellAvailable: false,
        onSell: () {
          sAnalytics.sellClick(source: 's Menu');
          if (kycState.sellStatus == kycOperationStatus(KycStatus.allowed)) {
            showSellAction(context);
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.sellStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showSellAction(context),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onConvert: () {
          sAnalytics.convertClick(source: 's Menu');
          if (kycState.sellStatus == kycOperationStatus(KycStatus.allowed)) {
            sRouter.pop();

            sAnalytics.convertPageView();

            sRouter.push(
              ConvertRouter(),
            );
          } else {
            Navigator.of(context).pop();

            kycAlertHandler.handle(
              status: kycState.sellStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => sRouter.push(
                ConvertRouter(),
              ),
              navigatePop: true,
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onDeposit: () {
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            showDepositAction(context);
          } else {
            sRouter.pop();

            kycAlertHandler.handle(
              status: kycState.depositStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showDepositAction(context),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onWithdraw: () {
          if (kycState.withdrawalStatus ==
              kycOperationStatus(KycStatus.allowed)) {
            showWithdrawAction(context);
          } else {
            sRouter.pop();

            kycAlertHandler.handle(
              status: kycState.withdrawalStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showWithdrawAction(context),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onSend: () {
          sAnalytics.sendClick(source: 'S Menu');
          if (kycState.withdrawalStatus ==
              kycOperationStatus(KycStatus.allowed)) {
            sAnalytics.sendChooseAsset();

            showSendAction(context, isNotEmptyBalance: isNotEmptyBalance);
          } else {
            Navigator.of(context).pop();

            kycAlertHandler.handle(
              status: kycState.withdrawalStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showSendAction(
                context,
                isNotEmptyBalance: isNotEmptyBalance,
              ),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onReceive: () {
          sAnalytics.receiveClick(source: 'S Menu');
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            showReceiveAction(context);
          } else {
            Navigator.of(context).pop();

            kycAlertHandler.handle(
              status: kycState.depositStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showReceiveAction(context),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onDissmis: updateActionState,
        whenComplete: () {
          if (getIt.get<AppStore>().actionMenuActive) updateActionState();
        },
        transitionAnimationController: widget.transitionAnimationController,
        actionItemLocalized: localizedActionItems(context),
      );
    } else {
      sRouter.pop();
    }
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
