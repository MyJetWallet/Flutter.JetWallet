import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

CurrencyModel currentAsset = CurrencyModel.empty();

void showSendOptions(
  BuildContext context,
  CurrencyModel currency, {
  bool navigateBack = true,
}) {
  currentAsset = currency;
  if (navigateBack) {
    Navigator.pop(context);
  }

  final isToCryptoWalletAvaible = _checkToCryptoWalletAvaible();
  final isGlobalAvaible = _checkGlobalAvaible();
  final isGiftAvaible = _checkGiftAvaible();

  sAnalytics.sendToSheetScreenView(
    sendMethods: [
      if (isToCryptoWalletAvaible) AnalyticsSendMethods.cryptoWallet,
      if (isGlobalAvaible) AnalyticsSendMethods.globally,
      if (isGiftAvaible) AnalyticsSendMethods.gift,
    ],
  );

  if (!(isToCryptoWalletAvaible || isGlobalAvaible || isGiftAvaible)) {
    sNotification.showError(
      intl.operation_bloked_text,
      duration: 4,
      id: 1,
      hideIcon: true,
    );

    return;
  }

  sShowBasicModalBottomSheet(
    context: context,
    then: (value) {},
    pinned: SBottomSheetHeader(
      name: intl.sendOptions_send,
    ),
    children: [
      Column(
        children: [
          if (isToCryptoWalletAvaible)
            SActionItem(
              icon: const SWallet2Icon(),
              name: intl.sendOptions_to_crypto_wallet,
              description: intl.sendOptions_actionItemDescription2,
              onTap: () {
                Navigator.pop(context);
                sRouter.push(
                  WithdrawRouter(
                    withdrawal: WithdrawalModel(
                      currency: currency,
                    ),
                  ),
                );
              },
            ),
          if (isGlobalAvaible)
            SActionItem(
              icon: const SNetworkIcon(),
              name: intl.global_send_name,
              description: intl.global_send_helper,
              onTap: () {
                Navigator.pop(context);
                showSendGlobally(
                  getIt<AppRouter>().navigatorKey.currentContext!,
                  currency,
                );
              },
            ),
          if (isGiftAvaible)
            SActionItem(
              icon: const SGiftSendIcon(),
              name: intl.send_gift,
              description: intl.send_gift_to_simple_wallet,
              onTap: () async {
                sAnalytics.tapOnTheGiftButton();
                Navigator.pop(context);
                await sRouter.push(
                  GiftReceiversDetailsRouter(
                    sendGiftInfo: SendGiftInfoModel(currency: currency),
                  ),
                );
              },
            ),
          const SpaceH40(),
        ],
      ),
    ],
  );
}

bool _checkIsBlockerNotContains(BlockingType blockingType) {
  final clientDetail = sSignalRModules.clientDetail;

  final result = clientDetail.clientBlockers.any(
    (element) => element.blockingType == blockingType,
  );

  return !result;
}

bool _checkToCryptoWalletAvaible() {
  final kycState = getIt.get<KycService>();

  final isAnySuportedByCurrencies = currentAsset.supportsCryptoWithdrawal && currentAsset.isAssetBalanceNotEmpty;

  final isNoKycBlocker = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
  final isNoClientBlocker = _checkIsBlockerNotContains(BlockingType.withdrawal);

  return isAnySuportedByCurrencies && isNoKycBlocker && isNoClientBlocker;
}

bool _checkGlobalAvaible() {
  final kycState = getIt.get<KycService>();

  final isAnySuportedByCurrencies = currentAsset.supportsGlobalSend;
  final isNoKycBlocker = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
  final isNoClientBlocker = _checkIsBlockerNotContains(BlockingType.withdrawal);

  return isAnySuportedByCurrencies && isNoKycBlocker && isNoClientBlocker;
}

bool _checkGiftAvaible() {
  final kycState = getIt.get<KycService>();

  final isAnySuportedByCurrencies = currentAsset.supportsGiftlSend && currentAsset.isAssetBalanceNotEmpty;
  final isNoKycBlocker = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
  final isNoClientBlocker = _checkIsBlockerNotContains(BlockingType.transfer);

  return isAnySuportedByCurrencies && isNoKycBlocker && isNoClientBlocker;
}
