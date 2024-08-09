import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/actions/circle_actions/circle_actions.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/convert_flow/utils/show_convert_to_bottom_sheet.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_with_bottom_sheet.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class WalletActionsRow extends StatelessWidget {
  const WalletActionsRow({super.key, required this.currency});

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: CircleActionButtons(
        isSendDisabled: currency.isAssetBalanceEmpty,
        isSellDisabled: currency.isAssetBalanceEmpty,
        isConvertDisabled: currency.isAssetBalanceEmpty,
        onBuy: () {
          sAnalytics.tapOnTheBuyWalletButton(
            source: 'Wallets - Wallet - Buy',
          );

          final actualAsset = currency;

          final isCardsAvailable = actualAsset.buyMethods.any(
            (element) => element.id == PaymentMethodType.bankCard,
          );

          final isSimpleAccountAvaible = sSignalRModules.paymentProducts?.any(
                (element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount,
              ) ??
              false;

          final isBankingAccountsAvaible = actualAsset.buyMethods.any(
            (element) => element.id == PaymentMethodType.ibanTransferUnlimint,
          );

          final isBuyAvaible = isCardsAvailable || isSimpleAccountAvaible || isBankingAccountsAvaible;

          final isDepositBlocker = sSignalRModules.clientDetail.clientBlockers.any(
            (element) => element.blockingType == BlockingType.deposit,
          );

          if (kycState.tradeStatus == kycOperationStatus(KycStatus.blocked) || !isBuyAvaible) {
            sNotification.showError(
              intl.operation_bloked_text,
              id: 1,
            );
            sAnalytics.errorBuyIsUnavailable();
          } else if ((kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) &&
              !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false)) {
            sNotification.showError(
              intl.operation_bloked_text,
              id: 1,
            );
            sAnalytics.errorBuyIsUnavailable();
          } else if (isDepositBlocker && !(sSignalRModules.bankingProfileData?.isAvaibleAnyAccount ?? false)) {
            showSendTimerAlertOr(
              context: context,
              or: () => showPayWithBottomSheet(
                context: context,
                currency: actualAsset,
              ),
              from: [BlockingType.deposit],
            );
          } else if (isBuyAvaible) {
            showSendTimerAlertOr(
              context: context,
              or: () => showPayWithBottomSheet(
                context: context,
                currency: actualAsset,
              ),
              from: [BlockingType.trade],
            );
          } else {
            handler.handle(
              status: kycState.tradeStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => showPayWithBottomSheet(
                context: context,
                currency: actualAsset,
              ),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onSell: () {
          sAnalytics.tapOnTheSellButton(
            source: 'Wallet - Buy',
          );

          final actualAsset = currency;

          handler.handle(
            multiStatus: [
              kycState.tradeStatus,
            ],
            isProgress: kycState.verificationInProgress,
            currentNavigate: () => showSendTimerAlertOr(
              context: context,
              from: [BlockingType.trade],
              or: () {
                showSellPayWithBottomSheet(
                  context: context,
                  currency: actualAsset,
                  onSelected: ({account, card}) {
                    sRouter.push(
                      AmountRoute(
                        tab: AmountScreenTab.sell,
                        asset: actualAsset,
                        account: account,
                        simpleCard: card,
                      ),
                    );
                  },
                );
              },
            ),
            requiredDocuments: kycState.requiredDocuments,
            requiredVerifications: kycState.requiredVerifications,
          );
        },
        onReceive: () {
          sAnalytics.tapOnTheReceiveButton(
            source: 'My Assets - Receive',
          );
          final actualAsset = currency;
          if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed) && currency.supportsCryptoDeposit) {
            showSendTimerAlertOr(
              context: context,
              or: () => sRouter.navigate(
                CryptoDepositRouter(
                  header: intl.balanceActionButtons_receive,
                  currency: actualAsset,
                ),
              ),
              from: [BlockingType.deposit],
            );
          } else if (!currency.supportsCryptoDeposit) {
            sNotification.showError(
              intl.operation_bloked_text,
              id: 1,
            );
          } else {
            handler.handle(
              status: kycState.depositStatus,
              isProgress: kycState.verificationInProgress,
              currentNavigate: () => sRouter.navigate(
                CryptoDepositRouter(
                  header: intl.balanceActionButtons_receive,
                  currency: actualAsset,
                ),
              ),
              requiredDocuments: kycState.requiredDocuments,
              requiredVerifications: kycState.requiredVerifications,
            );
          }
        },
        onSend: () {
          sAnalytics.tabOnTheSendButton(
            source: 'My Assets - Asset - Send',
          );

          final actualAsset = currency;

          handler.handle(
            multiStatus: [],
            isProgress: kycState.verificationInProgress,
            currentNavigate: () => showSendOptions(
              context,
              actualAsset,
              navigateBack: false,
            ),
            requiredDocuments: kycState.requiredDocuments,
            requiredVerifications: kycState.requiredVerifications,
          );
        },
        onConvert: () {
          sAnalytics.tapOnTheConvertButton(
            source: 'Wallet - Convert',
          );
          final actualAsset = currency;

          handler.handle(
            multiStatus: [
              kycState.tradeStatus,
            ],
            isProgress: kycState.verificationInProgress,
            currentNavigate: () => showSendTimerAlertOr(
              context: context,
              or: () {
                showConvertToBottomSheet(
                  context: context,
                  fromAsset: actualAsset,
                );
              },
              from: [BlockingType.trade],
            ),
            requiredDocuments: kycState.requiredDocuments,
            requiredVerifications: kycState.requiredVerifications,
          );
        },
      ),
    );
  }
}
