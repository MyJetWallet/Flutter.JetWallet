import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../shared/features/actions/action_buy/action_buy.dart';
import '../../../../shared/features/actions/action_receive/action_receive.dart';
import '../../../../shared/features/actions/action_send/action_send.dart';
import '../../../../shared/features/convert/view/convert.dart';
import '../../../../shared/features/kyc/provider/kyc_verified_pod.dart';
import '../../../../shared/helpers/is_balance_empty.dart';
import '../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../provider/navigation_stpod.dart';

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
    final kycVerified = useProvider(kycVerifiedPod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

    final isNotEmptyBalance = !isBalanceEmpty(currencies);

    void updateActionState() => actionActive.value = !actionActive.value;

    return SBottomNavigationBar(
      profileNotifications: 2,
      selectedIndex: navigation.state,
      actionActive: actionActive.value,
      animationController: transitionAnimationController,
      onActionTap: () {
        if (!actionActive.value) {
          sShowMenuActionSheet(
            context: context,
            isNotEmptyBalance: isNotEmptyBalance,
            onBuy: () => showBuyAction(context),
            onSell: () {
              Navigator.of(context).pop();
              kycAlertHandler.handleSell(
                kycVerified.depositStatus,
                kycVerified,
              );
            },
            onConvert: () => navigatorPush(context, const Convert()),
            onDeposit: () {
              Navigator.of(context).pop();
              kycAlertHandler.handleDeposit(
                kycVerified.depositStatus,
                kycVerified,
              );
            },
            onWithdraw: () {
              kycAlertHandler.handleWithdrawal(
                kycVerified.depositStatus,
                kycVerified,
              );
            },
            onSend: () => showSendAction(context),
            onReceive: () => showReceiveAction(context),
            onDissmis: updateActionState,
            whenComplete: () {
              if (actionActive.value) updateActionState();
            },
            transitionAnimationController: transitionAnimationController,
          );
        } else {
          Navigator.pop(context);
        }
        updateActionState();
      },
      onChanged: (value) => navigation.state = value,
    );
  }
}
