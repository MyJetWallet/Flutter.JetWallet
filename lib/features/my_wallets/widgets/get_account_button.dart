import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_address_info.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class GetAccountButton extends StatelessObserverWidget {
  const GetAccountButton({
    super.key,
    required this.store,
  });

  final MyWalletsSrore store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 16,
        left: 60,
        right: store.buttonStatus == BankingShowState.getAccount ? 60 : 30,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: store.buttonStatus == BankingShowState.getAccount ? null : double.infinity,
        child: SIconTextButton(
          onTap: () {
            sAnalytics.tapOnTheButtonGetAccountEUROnWalletsScreen();
            onGetAccountClick(store, context);
          },
          text: store.simpleAccountButtonText,
          mainAxisSize: store.buttonStatus == BankingShowState.getAccount ? MainAxisSize.min : MainAxisSize.max,
          icon: store.buttonStatus == BankingShowState.getAccount
              ? SBankMediumIcon(color: sKit.colors.blue)
              : Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: sKit.colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SBankMediumIcon(color: sKit.colors.white),
                  ),
                ),
          rightIcon: store.buttonStatus == BankingShowState.accountList
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: SBlueRightArrowIcon(color: sKit.colors.black),
                )
              : null,
          textStyle: store.buttonStatus == BankingShowState.getAccount
              ? sTextButtonStyle.copyWith(
                  color: sKit.colors.purple,
                  fontWeight: FontWeight.w600,
                )
              : store.buttonStatus == BankingShowState.inProgress
                  ? sBodyText2Style.copyWith(
                      color: sKit.colors.grey1,
                      fontWeight: FontWeight.w600,
                    )
                  : sBodyText2Style.copyWith(
                      color: sKit.colors.black,
                      fontWeight: FontWeight.w600,
                    ),
        ),
      ),
    );
  }
}

Future<void> onGetAccountClick(MyWalletsSrore store, BuildContext context) async {
  final kycState = getIt.get<KycService>();
  final kyc = getIt.get<KycAlertHandler>();

  final kycPassed = checkKycPassed(
    kycState.depositStatus,
    kycState.sellStatus,
    kycState.withdrawalStatus,
  );
  final kycBlocked = checkKycBlocked(
    kycState.depositStatus,
    kycState.sellStatus,
    kycState.withdrawalStatus,
  );

  final verificationInProgress = kycState.inVerificationProgress;
  final isKyc = !kycPassed && !kycBlocked && !verificationInProgress;

  if (verificationInProgress) {
    kyc.showVerifyingAlert();

    return;
  }

  if (kycBlocked) {
    kyc.showBlockedAlert();

    return;
  }

  print(store.buttonStatus);

  if (store.buttonStatus == BankingShowState.getAccountBlock) {
    kyc.showBlockedAlert();

    return;
  } else if (store.buttonStatus == BankingShowState.inProgress) {
    kyc.showVerifyingAlert();

    return;
  } else if (store.buttonStatus == BankingShowState.accountList) {
    await sRouter.push(const CJAccountRouter());

    return;
  } else if (store.buttonStatus == BankingShowState.getAccount) {
    await store.createSimpleAccount();
  }

  /*
  if (store.simpleStatus == SimpleAccountStatus.allowed) {
    await store.createSimpleAccount();
  } else if (isKyc || store.simpleStatus == SimpleAccountStatus.kycRequired) {
    showWalletVerifyAccount(context, after: afterVerification);
  } else if (store.simpleStatus == SimpleAccountStatus.addressRequired) {
    showWalletAdressInfo(context, after: afterVerification);
  }
  */
}
