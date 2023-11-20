import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/my_wallets/helper/show_wallet_verify_account.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/helpers/check_kyc_status.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../../core/services/user_info/user_info_service.dart';

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
    final userInfo = getIt.get<UserInfoService>();

    final isButtonSmall =
        store.buttonStatus == BankingShowState.getAccount || store.buttonStatus == BankingShowState.getAccountBlock;

    final isAnyBankAccountInCreating = (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
        .where((element) => element.status == AccountStatus.inCreation)
        .isNotEmpty;
    final isSimpleInCreating = sSignalRModules.bankingProfileData?.simple?.account?.status == AccountStatus.inCreation;
    final isCardInCreating = (sSignalRModules.bankingProfileData?.banking?.cards ?? [])
        .where((element) => element.status == AccountStatusCard.inCreation)
        .isNotEmpty;

    final isLoadingState = store.buttonStatus == BankingShowState.inProgress ||
        isAnyBankAccountInCreating ||
        isSimpleInCreating ||
        isCardInCreating;

    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 10,
        left: 60,
        right: isButtonSmall ? 60 : 30,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isButtonSmall ? null : double.infinity,
        child: SIconTextButton(
          onTap: () {
            sAnalytics.tapOnTheButtonGetAccountEUROnWalletsScreen();
            onGetAccountClick(store, context, eurCurrency);
          },
          text: isLoadingState ? intl.my_wallets_create_account : store.simpleCardButtonText,
          mainAxisSize: isButtonSmall ? MainAxisSize.min : MainAxisSize.max,
          icon: isLoadingState
              ? SizedBox(
                  width: 13.3,
                  height: 13.3,
                  child: CircularProgressIndicator(
                    color: sKit.colors.grey1,
                    strokeWidth: 1,
                  ),
                )
              : isButtonSmall
                  ? SBankMediumIcon(color: sKit.colors.blue)
                  : Stack(
                      children: [
                        if ((sSignalRModules.bankingProfileData?.banking?.cards
                                        ?.where(
                                          (element) =>
                                              element.status == AccountStatusCard.active ||
                                              element.status == AccountStatusCard.frozen,
                                        )
                                        .toList()
                                        .length ??
                                    0) >
                                0 &&
                            userInfo.isSimpleCardAvailable) ...[
                          const SizedBox(
                            width: 55,
                          ),
                          const Positioned(
                            left: 19,
                            child: SWalletCardIcon(
                              width: 36,
                              height: 24,
                            ),
                          ),
                        ],
                        Container(
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
                      ],
                    ),
          rightIcon: store.buttonStatus == BankingShowState.accountList
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: SBlueRightArrowIcon(color: sKit.colors.black),
                )
              : null,
          textStyle: isButtonSmall
              ? sTextButtonStyle.copyWith(
                  color: sKit.colors.purple,
                  fontWeight: FontWeight.w600,
                )
              : isLoadingState
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

  if (store.buttonStatus == BankingShowState.getAccountBlock) {
    sNotification.showError(
      intl.operation_is_unavailable,
      duration: 8,
      id: 1,
      needFeedback: true,
    );

    return;
  }

  final verificationInProgress = kycState.inVerificationProgress;

  if (verificationInProgress) {
    return;
  }

  if (store.buttonStatus == BankingShowState.getAccountBlock) {
    await store.createSimpleAccount();

    return;
  } else if (store.buttonStatus == BankingShowState.inProgress) {
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
