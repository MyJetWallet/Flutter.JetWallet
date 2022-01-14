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
import '../../../../shared/features/kyc/model/kyc_operation_status_model.dart';
import '../../../../shared/features/kyc/provider/kyc_checks_fpod.dart';
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

    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

    final kycChecks = useProvider(kycChecksFpod);

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
              kycChecks.whenData(
                (value) => kycAlertHandler.handle(
                  value.sellStatus,
                  value,
                  KycStatusType.sell,
                ),
              );
            },
            onConvert: () => navigatorPush(context, const Convert()),
            onDeposit: () {
              Navigator.of(context).pop();
              kycChecks.whenData(
                (value) => kycAlertHandler.handle(
                  value.depositStatus,
                  value,
                  KycStatusType.deposit,
                ),
              );
            },
            onWithdraw: () {
              Navigator.of(context).pop();
              kycChecks.whenData(
                (value) => kycAlertHandler.handle(
                  value.withdrawalStatus,
                  value,
                  KycStatusType.withdrawal,
                ),
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
