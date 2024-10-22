import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/action_send.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

CurrencyModel currentAsset = CurrencyModel.empty();

void showSendOptions(
  BuildContext context,
  CurrencyModel currency, {
  required Function() onBuyPressed,
  bool navigateBack = true,
}) {
  currentAsset = currency;
  if (navigateBack) {
    Navigator.pop(context);
  }

  final isToCryptoWalletAvaible = _checkToCryptoWalletAvaible();
  final isGlobalAvaible = _checkGlobalAvaible();
  final isGiftAvaible = _checkGiftAvaible();

  if (currentAsset.networksForBlockchainSend.isEmpty) {
    showAssetOnlyTradableWithinSimpleAppDialog();

    return;
  } else if (currency.isAssetBalanceEmpty) {
    showPleaseAddFundsToYourBalanceDialog(onBuyPressed);

    return;
  }

  if (!(isToCryptoWalletAvaible || isGlobalAvaible || isGiftAvaible)) {
    showSendTimerAlertOr(
      context: context,
      or: () {
        if (currentAsset.networksForBlockchainSend.isNotEmpty) {
          sNotification.showError(
            intl.operation_bloked_text,
            id: 1,
          );
        } else {
          showAssetOnlyTradableWithinSimpleAppDialog();
        }
      },
      from: [BlockingType.transfer, BlockingType.withdrawal],
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
            SCardRow(
              icon: const SWallet2Icon(),
              name: intl.sendOptions_to_crypto_wallet,
              helper: intl.sendOptions_actionItemDescription2,
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
              amount: '',
              description: '',
            ),
          if (isGlobalAvaible)
            SCardRow(
              icon: const SNetworkIcon(),
              name: intl.global_send_name,
              helper: intl.global_send_helper,
              onTap: () {
                Navigator.pop(context);
                showSendGlobally(
                  getIt<AppRouter>().navigatorKey.currentContext!,
                  currency,
                );
              },
              amount: '',
              description: '',
            ),
          if (isGiftAvaible)
            SCardRow(
              icon: const SGiftSendIcon(),
              name: intl.send_gift,
              helper: intl.send_gift_to_simple_wallet,
              onTap: () async {
                Navigator.pop(context);
                await sRouter.push(
                  GiftReceiversDetailsRouter(
                    sendGiftInfo: SendGiftInfoModel(currency: currency),
                  ),
                );
              },
              amount: '',
              description: '',
            ),
          if (isGlobalAvaible)
            SCardRow(
              icon: Assets.svg.medium.bank.simpleSvg(color: SColorsLight().blue),
              onTap: () {
                Navigator.pop(context);
                showBankTransferTo(context, currency);
              },
              amount: '',
              description: '',
              name: intl.bank_transfer,
              helper: intl.bank_transfer_to_yourself,
            ),
          const SpaceH40(),
        ],
      ),
    ],
  );
}

void showPleaseAddFundsToYourBalanceDialog(Function() onBuyPressed) {
  sShowAlertPopup(
    sRouter.navigatorKey.currentContext!,
    image: Assets.svg.brand.small.infoYellow.simpleSvg(),
    primaryText: '',
    secondaryText: intl.wallet_please_add_funds_to_your_balance,
    primaryButtonName: intl.wallet_buy_crypto,
    onPrimaryButtonTap: () {
      sRouter.maybePop();
      onBuyPressed();
    },
    secondaryButtonName: intl.wallet_cancel,
    onSecondaryButtonTap: () {
      sRouter.maybePop();
    },
  );
}

void showAssetOnlyTradableWithinSimpleAppDialog() {
  sShowAlertPopup(
    sRouter.navigatorKey.currentContext!,
    image: Assets.svg.brand.small.infoYellow.simpleSvg(),
    primaryText: '',
    secondaryText: intl.wallet_this_asset_is_only_tradable_within_simple,
    primaryButtonName: intl.wallet_got_it,
    onPrimaryButtonTap: () {
      sRouter.maybePop();
    },
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
