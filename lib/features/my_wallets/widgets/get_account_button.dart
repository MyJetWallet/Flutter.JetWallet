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
        right: store.buttonStatus == SimpleWalletAccountStatus.none ? 60 : 30,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: store.buttonStatus == SimpleWalletAccountStatus.none ? null : double.infinity,
        child: SIconTextButton(
          onTap: () {
            sAnalytics.tapOnTheButtonGetAccountEUROnWalletsScreen();
            onGetAccountClick(store, context);
          },
          text: store.simpleAccountButtonText,
          mainAxisSize: store.buttonStatus == SimpleWalletAccountStatus.none ? MainAxisSize.min : MainAxisSize.max,
          icon: store.buttonStatus == SimpleWalletAccountStatus.none
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
          rightIcon: store.buttonStatus == SimpleWalletAccountStatus.created
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: SBlueRightArrowIcon(color: sKit.colors.black),
                )
              : null,
          textStyle: store.buttonStatus == SimpleWalletAccountStatus.none
              ? sTextButtonStyle.copyWith(
                  color: sKit.colors.purple,
                  fontWeight: FontWeight.w600,
                )
              : store.buttonStatus == SimpleWalletAccountStatus.creating
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
  if (store.simpleAccontStatus == SimpleWalletAccountStatus.created) return;

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

  Future<void> afterVerification() async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.warning,
          place: 'Wallet',
          message: 'after verification Get Simple Account',
        );

    sNotification.showError(intl.let_us_create_account, isError: false);
    store.setSimpleAccountStatus(SimpleWalletAccountStatus.creating);
  }

  if (verificationInProgress) {
    kyc.showVerifyingAlert();

    return;
  }

  if (kycBlocked) {
    kyc.showBlockedAlert();

    return;
  }

  if (store.buttonStatus == SimpleWalletAccountStatus.blocked) {
    kyc.showBlockedAlert();

    return;
  } else if (store.buttonStatus == SimpleWalletAccountStatus.creating ||
      store.buttonStatus == SimpleWalletAccountStatus.createdAndcreating) {
    kyc.showVerifyingAlert();

    return;
  } else if (store.buttonStatus == SimpleWalletAccountStatus.created) {
    await sRouter.push(const CJAccountRouter());

    return;
  }

  if (store.simpleStatus == SimpleAccountStatus.allowed) {
    await store.createSimpleAccount();
  } else if (isKyc || store.simpleStatus == SimpleAccountStatus.kycRequired) {
    showWalletVerifyAccount(context, after: afterVerification);
  } else if (store.simpleStatus == SimpleAccountStatus.addressRequired) {
    showWalletAdressInfo(context, after: afterVerification);
  }
}
