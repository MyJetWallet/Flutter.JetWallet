import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';


Future<void> onGetAccountClick(MyWalletsSrore store, BuildContext context, CurrencyModel eurCurrency) async {
  final kycState = getIt.get<KycService>();

  if (store.buttonStatus == BankingShowState.getAccountBlock) {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 1,
      needFeedback: true,
    );

    return;
  }

  final verificationInProgress = kycState.inVerificationProgress;

  if (verificationInProgress) {
    final kycAlertHandler = getIt.get<KycAlertHandler>();
    kycAlertHandler.showVerifyingAlert();

    return;
  }

  if (store.buttonStatus == BankingShowState.getAccountBlock) {
    await store.createSimpleAccount();

    return;
  } else if (store.buttonStatus == BankingShowState.inProgress) {
    return;
  } else if (store.buttonStatus == BankingShowState.accountList) {
    await sRouter.push(
      WalletRouter(
        currency: eurCurrency,
      ),
    );

    return;
  } else if (store.buttonStatus == BankingShowState.getAccount) {
    await store.createSimpleAccount();
  } else if (store.buttonStatus == BankingShowState.onlySimple) {
    if (sSignalRModules.bankingProfileData?.simple?.account != null) {
      await sRouter
          .push(
            CJAccountRouter(
              bankingAccount: sSignalRModules.bankingProfileData!.simple!.account!,
              isCJAccount: true,
            ),
          )
          .then(
            (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
              isCJ: true,
              eurAccountLabel: sSignalRModules.bankingProfileData!.simple!.account!.label ?? '',
              isHasTransaction: false,
            ),
          );
    }

    return;
  }
}
