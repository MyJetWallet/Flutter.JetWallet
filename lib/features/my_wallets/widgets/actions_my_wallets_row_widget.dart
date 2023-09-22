import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_receive/action_receive.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class ActionsMyWalletsRowWidget extends StatelessWidget {
  const ActionsMyWalletsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final isNotEmptyBalance = !areBalancesEmpty(currencies);

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final isShowBuy = sSignalRModules.currenciesList
        .where((element) => element.buyMethods.isNotEmpty)
        .isNotEmpty;
    final isShowSend = sSignalRModules.currenciesList
        .where(
          (element) =>
              element.isSupportAnyWithdrawal && element.isAssetBalanceNotEmpty,
        )
        .isNotEmpty;
    final isShowReceive = sSignalRModules.currenciesList
        .where((element) => element.supportsCryptoDeposit)
        .isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (isShowBuy) ...[
          CircleActionBuy(
            onTap: () {
              sAnalytics.newBuyTapBuy(
                source: 'My Assets - Buy',
              );
              showBuyAction(
                shouldPop: false,
                context: context,
              );
            },
          ),
        ],
        if (isShowReceive) ...[
          CircleActionReceive(
            onTap: () {
              sAnalytics.tapOnTheReceiveButton(
                source: 'My Assets - Receive',
              );

              if (kycState.depositStatus ==
                  kycOperationStatus(KycStatus.allowed)) {
                showReceiveAction(context, shouldPop: false);
              } else {
                kycAlertHandler.handle(
                  status: kycState.depositStatus,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () => showReceiveAction(
                    context,
                    shouldPop: false,
                  ),
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
          ),
        ],
        if (isShowSend) ...[
          CircleActionSend(
            onTap: () {
              sAnalytics.tabOnTheSendButton(source: 'My Assets - Send');
              if (kycState.withdrawalStatus ==
                  kycOperationStatus(KycStatus.allowed)) {
                showSendAction(
                  context,
                  isNotEmptyBalance: isNotEmptyBalance,
                  shouldPop: false,
                );
              } else {
                kycAlertHandler.handle(
                  status: kycState.withdrawalStatus,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () => showSendAction(
                    context,
                    isNotEmptyBalance: isNotEmptyBalance,
                    shouldPop: false,
                  ),
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
          ),
        ],
        CircleActionExchange(
          onTap: () {
            if (kycState.sellStatus == kycOperationStatus(KycStatus.allowed)) {
              showSendTimerAlertOr(
                context: context,
                or: () => sRouter.push(ConvertRouter()),
                from: BlockingType.trade,
              );
            } else {
              kycAlertHandler.handle(
                status: kycState.sellStatus,
                isProgress: kycState.verificationInProgress,
                currentNavigate: () => showSendTimerAlertOr(
                  context: context,
                  or: () => sRouter.push(ConvertRouter()),
                  from: BlockingType.trade,
                ),
                requiredDocuments: kycState.requiredDocuments,
                requiredVerifications: kycState.requiredVerifications,
              );
            }
          },
        ),
      ],
    );
  }
}
