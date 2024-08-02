import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/send_options.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/convert_flow/utils/show_convert_to_bottom_sheet.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_with_bottom_sheet.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

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
    final handler = getIt.get<KycAlertHandler>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (marketItem.symbol == 'CPWR') ...[
          SPaddingH24(
            child: Column(
              children: [
                SPrimaryButton1(
                  name: '${intl.balanceActionButtons_buy} ${marketItem.name}',
                  onTap: () {
                    if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed)) {
                      showPayWithBottomSheet(
                        context: context,
                        currency: currency,
                      );
                    } else {
                      sNotification.showError(
                        intl.operation_bloked_text,
                        id: 1,
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
            isSendDisabled: currency.isAssetBalanceEmpty,
            isSellDisabled: currency.isAssetBalanceEmpty,
            isConvertDisabled: currency.isAssetBalanceEmpty,
            onBuy: () {
              sAnalytics.tapOnTheBuyWalletButton(
                source: 'Market - Wallet - Buy',
              );

              final isCardsAvailable = currency.buyMethods.any((element) => element.id == PaymentMethodType.bankCard);

              final isSimpleAccountAvaible = sSignalRModules.paymentProducts?.any(
                    (element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount,
                  ) ??
                  false;

              final isBankingAccountsAvaible = currency.buyMethods.any(
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
                    currency: currency,
                  ),
                  from: [BlockingType.deposit],
                );
              } else if (isBuyAvaible) {
                showSendTimerAlertOr(
                  context: context,
                  or: () => showPayWithBottomSheet(
                    context: context,
                    currency: currency,
                  ),
                  from: [BlockingType.trade],
                );
              } else {
                handler.handle(
                  status: kycState.tradeStatus,
                  isProgress: kycState.verificationInProgress,
                  currentNavigate: () => showPayWithBottomSheet(
                    context: context,
                    currency: currency,
                  ),
                  requiredDocuments: kycState.requiredDocuments,
                  requiredVerifications: kycState.requiredVerifications,
                );
              }
            },
            onSell: () {
              sAnalytics.tapOnTheSellButton(
                source: 'Market - Buy',
              );

              handler.handle(
                multiStatus: [
                  kycState.tradeStatus,
                ],
                isProgress: kycState.verificationInProgress,
                currentNavigate: () => showSendTimerAlertOr(
                  context: context,
                  or: () {
                    showSellPayWithBottomSheet(
                      context: context,
                      currency: currency,
                      onSelected: ({account, card}) {
                        sRouter.push(
                          AmountRoute(
                            tab: AmountScreenTab.sell,
                            asset: currency,
                            account: account,
                            simpleCard: card,
                          ),
                        );
                      },
                    );
                  },
                  from: [BlockingType.trade],
                ),
                requiredDocuments: kycState.requiredDocuments,
                requiredVerifications: kycState.requiredVerifications,
              );
            },
            onReceive: () {
              sAnalytics.tapOnTheReceiveButton(
                source: 'Market - Asset - Receive',
              );

              if (currency.type == AssetType.crypto) {
                if (kycState.depositStatus == kycOperationStatus(KycStatus.allowed) && currency.supportsCryptoDeposit) {
                  showSendTimerAlertOr(
                    context: context,
                    or: () => sRouter.navigate(
                      CryptoDepositRouter(
                        header: intl.balanceActionButtons_receive,
                        currency: currency,
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
                        currency: currency,
                      ),
                    ),
                    requiredDocuments: kycState.requiredDocuments,
                    requiredVerifications: kycState.requiredVerifications,
                  );
                }
              } else {
                sRouter.popUntilRoot();
                getIt<BottomBarStore>().setHomeTab(BottomItemType.home);
              }
            },
            onSend: () {
              sAnalytics.tabOnTheSendButton(
                source: 'Market - Asset - Send',
              );

              handler.handle(
                isProgress: kycState.verificationInProgress,
                currentNavigate: () => showSendOptions(
                  context,
                  currency,
                  navigateBack: false,
                ),
                requiredDocuments: kycState.requiredDocuments,
                requiredVerifications: kycState.requiredVerifications,
              );
            },
            onConvert: () {
              sAnalytics.tapOnTheConvertButton(
                source: 'Market - Convert',
              );

              handler.handle(
                multiStatus: [
                  kycState.tradeStatus,
                ],
                isProgress: kycState.verificationInProgress,
                currentNavigate: () => showSendTimerAlertOr(
                  context: context,
                  or: () => showConvertToBottomSheet(
                    context: context,
                    fromAsset: currency,
                  ),
                  from: [BlockingType.trade],
                ),
                requiredDocuments: kycState.requiredDocuments,
                requiredVerifications: kycState.requiredVerifications,
              );
            },
          ),
        ],
      ],
    );
  }
}
