import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/show_account_details_screen.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

Future<void> showSelectAccountForAddCash(BuildContext context) async {
  final kycState = getIt.get<KycService>();

  if (kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) {
    sNotification.showError(
      intl.operation_bloked_text,
      id: 1,
      needFeedback: true,
    );

    sAnalytics.errorDepositIsUnavailable();

    return;
  }

  sAnalytics.depositToScreenView();

  showSendTimerAlertOr(
    context: context,
    from: [BlockingType.deposit],
    or: () async {
      if (MyWalletsSrore.of(context).buttonStatus == BankingShowState.getAccount) {
        await MyWalletsSrore.of(context).createSimpleAccount();
      } else {
        sShowBasicModalBottomSheet(
          context: context,
          pinned: SBottomSheetHeader(
            name: intl.add_cash_to,
          ),
          scrollable: true,
          children: [
            const SpaceH12(),
            const _ShowSelectAccountForAddCash(),
            const SpaceH42(),
          ],
        );
      }
    },
  );
}

class _ShowSelectAccountForAddCash extends StatelessObserverWidget {
  const _ShowSelectAccountForAddCash();

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final bankAccounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? <SimpleBankingAccount>[];
    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SPaddingH24(
          child: Text(
            intl.sell_amount_accounts,
            style: sBodyText2Style.copyWith(
              color: sKit.colors.grey2,
            ),
          ),
        ),
        if (simpleAccount != null)
          SCardRow(
            maxWidth: MediaQuery.of(context).size.width * .35,
            icon: Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: sKit.colors.blue,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 16,
                height: 16,
                child: SBankMediumIcon(
                  color: sKit.colors.white,
                ),
              ),
            ),
            name: simpleAccount.label ?? 'Account 1',
            helper: simpleAccount.status == AccountStatus.active
                ? intl.eur_wallet_simple_account
                : intl.create_simple_creating,
            onTap: () {
              if (simpleAccount.status == AccountStatus.active) {
                sAnalytics.eurWalletDepositDetailsSheet(
                  isCJ: true,
                  eurAccountLabel: simpleAccount.label ?? 'Account 1',
                  isHasTransaction: true,
                  source: 'Wallets',
                );

                sAnalytics.tapOnAnyEurAccountOnDepositButton(
                  accountType: 'CJ',
                );

                sRouter.pop();

                showAccountDetails(
                  context: context,
                  onClose: () {
                    sAnalytics.eurWalletTapCloseOnDeposirSheet(
                      isCJ: true,
                      eurAccountLabel: simpleAccount.label ?? 'Account 1',
                      isHasTransaction: true,
                    );
                  },
                  bankingAccount: simpleAccount,
                );
              }
            },
            description: '',
            amount: '',
            needSpacer: true,
            rightIcon: simpleAccount.status == AccountStatus.active
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFF1F4F8)),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      volumeFormat(
                        decimal: simpleAccount.balance ?? Decimal.zero,
                        accuracy: eurCurrency.accuracy,
                        symbol: eurCurrency.symbol,
                      ),
                      style: sSubtitle1Style.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : null,
          ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: bankAccounts.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SCardRow(
              maxWidth: bankAccounts[index].status == AccountStatus.active
                  ? MediaQuery.of(context).size.width * .35
                  : MediaQuery.of(context).size.width * .5,
              icon: Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: sKit.colors.blue,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SBankMediumIcon(
                    color: sKit.colors.white,
                  ),
                ),
              ),
              name: bankAccounts[index].label ?? 'Account',
              helper: bankAccounts[index].status == AccountStatus.active
                  ? intl.eur_wallet_personal_account
                  : intl.create_personal_creating,
              onTap: () {
                sAnalytics.tapOnAnyEurAccountOnDepositButton(
                  accountType: 'Unlimit',
                );

                if (bankAccounts[index].status == AccountStatus.active) {
                  sAnalytics.eurWalletDepositDetailsSheet(
                    isCJ: false,
                    eurAccountLabel: bankAccounts[index].label ?? 'Account 1',
                    isHasTransaction: true,
                    source: 'Wallets',
                  );
                  sRouter.pop();

                  showAccountDetails(
                    context: context,
                    onClose: () {
                      sAnalytics.eurWalletTapCloseOnDeposirSheet(
                        isCJ: false,
                        eurAccountLabel: bankAccounts[index].label ?? 'Account',
                        isHasTransaction: true,
                      );
                    },
                    bankingAccount: bankAccounts[index],
                  );
                }
              },
              description: '',
              amount: '',
              needSpacer: true,
              rightIcon: bankAccounts[index].status == AccountStatus.active
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFF1F4F8)),
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        volumeFormat(
                          decimal: bankAccounts[index].balance ?? Decimal.zero,
                          accuracy: eurCurrency.accuracy,
                          symbol: eurCurrency.symbol,
                        ),
                        style: sSubtitle1Style.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }
}
