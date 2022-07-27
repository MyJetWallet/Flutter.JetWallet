import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/localized_action_items.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../shared/features/actions/action_buy/action_buy.dart';
import '../../../../shared/features/actions/action_deposit/action_deposit.dart';
import '../../../../shared/features/actions/action_receive/action_receive.dart';
import '../../../../shared/features/actions/action_sell/action_sell.dart';
import '../../../../shared/features/actions/action_send/action_send.dart';
import '../../../../shared/features/actions/action_withdraw/action_withdraw.dart';
import '../../../../shared/features/convert/view/convert.dart';
import '../../../../shared/features/earn/notifier/earn_profile_notipod.dart';
import '../../../../shared/features/kyc/helper/kyc_alert_handler.dart';
import '../../../../shared/features/kyc/model/kyc_operation_status_model.dart';
import '../../../../shared/features/kyc/model/kyc_verified_model.dart';
import '../../../../shared/features/kyc/notifier/kyc/kyc_notipod.dart';
import '../../../../shared/features/kyc/notifier/kyc_countries/kyc_countries_notipod.dart';
import '../../../../shared/helpers/are_balances_empty.dart';
import '../../../../shared/helpers/check_kyc_status.dart';
import '../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../provider/bottom_navigation_notipod.dart';
import '../../provider/navigation_stpod.dart';
import '../../provider/open_bottom_menu_spod.dart';

class BottomNavigationMenu extends HookWidget {
  const BottomNavigationMenu({
    Key? key,
    required this.transitionAnimationController,
  }) : super(key: key);

  final AnimationController transitionAnimationController;

  @override
  Widget build(BuildContext context) {
    final navigation = useProvider(navigationStpod);
    final currencies = useProvider(currenciesPod);
    final actionActive = useState(false);
    final userInfo = useProvider(userInfoNotipod);
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(kycAlertHandlerPod(context));
    final earnProfile = useProvider(earnProfileNotipod);
    final bottomMenuNotifier = useProvider(bottomNavigationNotipod);

    useProvider(kycCountriesNotipod);
    final openBottomMenu = useProvider(openBottomMenuSpod);

    final isNotEmptyBalance = !areBalancesEmpty(currencies);

    void updateActionState() => actionActive.value = !actionActive.value;

    // Todo: research better approach
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (openBottomMenu.state) {
        _openBottomMenu(
          context,
          actionActive,
          isNotEmptyBalance,
          kycState,
          kycAlertHandler,
          updateActionState,
        );
        openBottomMenu.state = false;
        updateActionState();
      }
    });

    return SBottomNavigationBar(
      profileNotifications: _profileNotificationLength(
        kycState,
        userInfo.twoFaEnabled,
      ),
      cardNotifications: bottomMenuNotifier.cardNotification,
      selectedIndex: navigation.state,
      actionActive: actionActive.value,
      earnEnabled: earnProfile.earnProfile?.earnEnabled ?? false,
      animationController: transitionAnimationController,
      onActionTap: () {
        _openBottomMenu(
          context,
          actionActive,
          isNotEmptyBalance,
          kycState,
          kycAlertHandler,
          updateActionState,
        );
        updateActionState();
      },
      onChanged: (value) => navigation.state = value,
    );
  }

  void _openBottomMenu(
    BuildContext context,
    ValueNotifier<bool> actionActive,
    bool isNotEmptyBalance,
    KycModel kycState,
    KycAlertHandler kycAlertHandler,
    Function() updateActionState,
  ) {
    if (!actionActive.value) {
      sShowMenuActionSheet(
        context: context,
        isNotEmptyBalance: isNotEmptyBalance,
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
        onSell: () {
          sAnalytics.sellClick(source: 's Menu');
          if (kycState.sellStatus == kycOperationStatus(KycStatus.allowed)) {
            showSellAction(context);
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.sellStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showSellAction(context),
            );
          }
        },
        onConvert: () {
          sAnalytics.convertClick(source: 's Menu');
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            Navigator.of(context).pop();
            sAnalytics.convertPageView();
            navigatorPush(context, const Convert());
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.depositStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => navigatorPush(context, const Convert()),
              navigatePop: true,
            );
          }
        },
        onDeposit: () {
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
            showDepositAction(context);
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.depositStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showDepositAction(context),
            );
          }
        },
        onWithdraw: () {
          if (kycState.withdrawalStatus ==
              kycOperationStatus(KycStatus.allowed)) {
            showWithdrawAction(context);
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.withdrawalStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showWithdrawAction(context),
            );
          }
        },
        onSend: () {
          sAnalytics.sendClick(source: 'S Menu');
          if (kycState.withdrawalStatus ==
              kycOperationStatus(KycStatus.allowed)) {
            sAnalytics.sendChooseAsset();
            showSendAction(context);
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.withdrawalStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showSendAction(context),
            );
          }
        },
        onReceive: () {
          sAnalytics.receiveClick(source: 'S Menu');
          if (kycState.withdrawalStatus ==
              kycOperationStatus(KycStatus.allowed)) {
            showReceiveAction(context);
          } else {
            Navigator.of(context).pop();
            kycAlertHandler.handle(
              status: kycState.withdrawalStatus,
              kycVerified: kycState,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showReceiveAction(context),
            );
          }
        },
        onDissmis: updateActionState,
        whenComplete: () {
          if (actionActive.value) updateActionState();
        },
        transitionAnimationController: transitionAnimationController,
        actionItemLocalized: localizedActionItems(context),
      );
    } else {
      Navigator.pop(context);
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
