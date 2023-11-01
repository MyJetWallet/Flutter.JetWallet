import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

void showSendOptions(
  BuildContext context,
  CurrencyModel currency, {
  bool navigateBack = true,
}) {
  if (navigateBack) {
    Navigator.pop(context);
  }

  sAnalytics.sendToSheetScreenView(
    sendMethods: [
      if (currency.supportsByAssetWithdrawal) AnalyticsSendMethods.cryptoWallet,
      if (currency.supporGlobalSendWithdrawal) AnalyticsSendMethods.globally,
      if (currency.supportIbanSendWithdrawal) AnalyticsSendMethods.bankAccount,
      if (currency.supportsGiftlSend && currency.type != AssetType.fiat) AnalyticsSendMethods.gift,
    ],
  );

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    pinned: SBottomSheetHeader(
      name: intl.sendOptions_send,
    ),
    children: [
      _SendOptions(
        currency: currency,
      ),
    ],
  );
}

class _SendOptions extends StatelessObserverWidget {
  const _SendOptions({
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SActionItem(
          icon: const SWallet2Icon(),
          name: intl.sendOptions_to_crypto_wallet,
          description: intl.sendOptions_actionItemDescription2,
          onTap: () {
            handleSendMethodBlockers(
              context: context,
              methodIsSuported: currency.supportsByAssetWithdrawal,
              onAllowed: () {
                Navigator.pop(context);
                sRouter.push(
                  WithdrawRouter(
                    withdrawal: WithdrawalModel(
                      currency: currency,
                    ),
                  ),
                );
              },
            );
          },
        ),
        SActionItem(
          icon: const SNetworkIcon(),
          name: intl.global_send_name,
          description: intl.global_send_helper,
          onTap: () {
            handleSendMethodBlockers(
              context: context,
              methodIsSuported: currency.supporGlobalSendWithdrawal,
              onAllowed: () {
                Navigator.pop(context);
                showSendGlobally(
                  getIt<AppRouter>().navigatorKey.currentContext!,
                  currency,
                );
              },
            );
          },
        ),
        SActionItem(
          icon: const SAccountIcon(),
          name: intl.sendOptions_to_bank_account,
          description: intl.iban_send_helper,
          onTap: () async {
            Navigator.pop(context);

            sRouter.popUntilRoot();

            await sRouter.replaceAll(
              [
                HomeRouter(
                  children: [
                    IBanRouter(
                      initIndex: 1,
                    ),
                  ],
                ),
              ],
            );

            if (getIt<AppStore>().tabsRouter != null) {
              getIt.get<AppStore>().setHomeTab(2);
              getIt<AppStore>().tabsRouter!.setActiveIndex(2);

              if (getIt.get<IbanStore>().ibanTabController != null) {
                getIt.get<IbanStore>().ibanTabController!.animateTo(
                      1,
                    );
              } else {
                getIt.get<IbanStore>().setInitTab(1);
              }
            }
          },
        ),
        SActionItem(
          icon: const SGiftSendIcon(),
          name: intl.send_gift,
          description: intl.send_gift_to_simple_wallet,
          onTap: () async {
            await handleSendMethodBlockers(
              context: context,
              methodIsSuported: currency.supportsGiftlSend && currency.type != AssetType.fiat,
              blockingType: BlockingType.transfer,
              onAllowed: () async {
                sAnalytics.tapOnTheGiftButton();
                Navigator.pop(context);
                await sRouter.push(
                  GiftReceiversDetailsRouter(
                    sendGiftInfo: SendGiftInfoModel(currency: currency),
                  ),
                );
              },
            );
          },
        ),
        const SpaceH40(),
      ],
    );
  }
}

Future<void> handleSendMethodBlockers({
  required BuildContext context,
  required void Function() onAllowed,
  bool methodIsSuported = true,
  BlockingType blockingType = BlockingType.withdrawal,
}) async {
  final kycState = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed) && methodIsSuported) {
    showSendTimerAlertOr(
      context: context,
      or: () {
        onAllowed();
      },
      from: [blockingType],
    );
  } else if (!methodIsSuported) {
    sNotification.showError(
      intl.my_wallets_actions_warning,
      id: 1,
      hideIcon: true,
    );
  } else {
    handler.handle(
      status: kycState.withdrawalStatus,
      isProgress: kycState.verificationInProgress,
      currentNavigate: () {
        onAllowed();
      },
      requiredDocuments: kycState.requiredDocuments,
      requiredVerifications: kycState.requiredVerifications,
    );
  }
}
