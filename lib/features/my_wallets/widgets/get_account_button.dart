import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
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
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 10,
        left: 60,
        right: store.buttonStatus == BankingShowState.getAccount ? 60 : 30,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: store.buttonStatus == BankingShowState.getAccount ? null : double.infinity,
        child: SIconTextButton(
          onTap: () {
            sAnalytics.tapOnTheButtonGetAccountEUROnWalletsScreen();
            onGetAccountClick(store, context, eurCurrency);
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

Future<void> onGetAccountClick(MyWalletsSrore store, BuildContext context, CurrencyModel eurCurrency) async {
  final kycState = getIt.get<KycService>();
  final kyc = getIt.get<KycAlertHandler>();

  final verificationInProgress = kycState.inVerificationProgress;

  if (verificationInProgress) {
    kyc.showVerifyingAlert();

    return;
  }

  if (store.buttonStatus == BankingShowState.getAccountBlock) {
    await store.createSimpleAccount();

    return;
  } else if (store.buttonStatus == BankingShowState.inProgress) {
    kyc.showVerifyingAlert();

    return;
  } else if (store.buttonStatus == BankingShowState.accountList) {
    await sRouter
        .push(
          WalletRouter(
            currency: eurCurrency,
          ),
        )
        .then((value) => sAnalytics.eurWalletTapBackOnAccountsScreen());

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
