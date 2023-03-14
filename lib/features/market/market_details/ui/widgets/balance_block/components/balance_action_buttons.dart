import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_buy.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_exchange.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_receive.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_send.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../actions/circle_actions/circle_actions.dart';
import '../../../../helper/currency_from.dart';

class BalanceActionButtons extends StatelessObserverWidget {
  const BalanceActionButtons({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(
      currencies,
      marketItem.associateAsset,
    );
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    return Row(
      children: [
        if (marketItem.symbol == 'CPWR') ...[
          SPaddingH24(
            child: Column(
              children: [
                SPrimaryButton1(
                  name: '${intl.balanceActionButtons_buy} ${marketItem.name}',
                  onTap: () {
                    if (kycState.depositStatus ==
                        kycOperationStatus(KycStatus.allowed)) {

                      sRouter.push(
                        PaymentMethodRouter(currency: currency),
                      );
                    } else {
                      kycAlertHandler.handle(
                        status: kycState.depositStatus,
                        isProgress: kycState.verificationInProgress,
                        navigatePop: true,
                        currentNavigate: () {

                          sRouter.push(
                            PaymentMethodRouter(currency: currency),
                          );
                        },
                        requiredDocuments: kycState.requiredDocuments,
                        requiredVerifications: kycState.requiredVerifications,
                      );
                    }
                  },
                  active: true,
                ),
              ],
            ),
          ),
        ] else ...[
          CircleActionButtons(
            showBuy: currency.supportsAtLeastOneBuyMethod,
            showReceive: currency.supportsCryptoDeposit,
            showExchange: currency.isAssetBalanceNotEmpty,
            showSend: currency.isAssetBalanceNotEmpty &&
                currency.supportsCryptoWithdrawal,
            onBuy: () {
              sAnalytics.newBuyTapBuy(
                source: 'Market - Asset - Buy',
              );
              if (kycState.depositStatus ==
                  kycOperationStatus(KycStatus.allowed)) {

                sRouter.push(
                  PaymentMethodRouter(currency: currency),
                );
              } else {
                kycAlertHandler.handle(
                  status: kycState.depositStatus,
                  isProgress: kycState.verificationInProgress,
                  navigatePop: true,
                  currentNavigate: () {

                    sRouter.push(
                      PaymentMethodRouter(currency: currency),
                    );
                  },
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
            onReceive: () {
              if (kycState.depositStatus ==
                  kycOperationStatus(KycStatus.allowed)) {
                sRouter.navigate(
                  CryptoDepositRouter(
                    header: intl.balanceActionButtons_receive,
                    currency: currency,
                  ),
                );
              } else {
                kycAlertHandler.handle(
                  status: kycState.depositStatus,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () {

                    sRouter.navigate(
                      CryptoDepositRouter(
                        header: intl.balanceActionButtons_receive,
                        currency: currency,
                      ),
                    );
                  },
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
            onSend: () {
              if (kycState.sellStatus ==
                  kycOperationStatus(KycStatus.allowed)) {
                showSendOptions(
                  context,
                  currency,
                  navigateBack: false,
                );
              } else {
                kycAlertHandler.handle(
                  status: kycState.sellStatus,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () {
                    showSendOptions(context, currency);
                  },
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
            onExchange: () {
              if (kycState.sellStatus ==
                  kycOperationStatus(KycStatus.allowed)) {
                sRouter.push(ConvertRouter(
                  fromCurrency: currency,
                ),);
              } else {
                kycAlertHandler.handle(
                  status: kycState.sellStatus,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () => sRouter.push(
                    ConvertRouter(
                      fromCurrency: currency,
                    ),
                  ),
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
          ),
        ],
      ],
    );
  }
}
