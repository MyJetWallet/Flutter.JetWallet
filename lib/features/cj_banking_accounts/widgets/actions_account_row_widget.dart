import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_setting_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/helper/show_deposit_details_popup.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_button.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

class ActionsAccountRowWidget extends StatelessWidget {
  const ActionsAccountRowWidget({
    super.key,
    required this.bankingAccount,
    required this.onChangeLableTap,
  });

  final SimpleBankingAccount bankingAccount;
  final void Function() onChangeLableTap;

  @override
  Widget build(BuildContext context) {
    final isCJAccount = bankingAccount.isClearjuctionAccount;

    final kycState = getIt.get<KycService>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Observer(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleActionButton(
                text: intl.wallet_add_cash,
                type: CircleButtonType.addCash,
                onTap: () {
                  if (kycState.depositStatus == kycOperationStatus(KycStatus.blocked)) {
                    sNotification.showError(
                      intl.operation_bloked_text,
                      id: 1,
                      needFeedback: true,
                    );

                    return;
                  }

                  showSendTimerAlertOr(
                    context: context,
                    from: [BlockingType.deposit],
                    or: () {
                      sAnalytics.eurWalletTapAddCashEurAccount(
                        isCJ: isCJAccount,
                        eurAccountLabel: bankingAccount.label ?? 'Account',
                        isHasTransaction: true,
                      );

                      sAnalytics.eurWalletDepositDetailsSheet(
                        isCJ: isCJAccount,
                        eurAccountLabel: bankingAccount.label ?? 'Account',
                        isHasTransaction: true,
                        source: 'EUR wallet',
                      );

                      showAccountDepositSelector(
                        context,
                        () {
                          sAnalytics.eurWalletTapCloseOnDeposirSheet(
                            isCJ: isCJAccount,
                            eurAccountLabel: bankingAccount.label ?? 'Account',
                            isHasTransaction: true,
                          );
                        },
                        isCJAccount,
                        bankingAccount,
                      );
                    },
                  );
                },
              ),
              CircleActionButton(
                text: intl.wallet_withdraw,
                type: CircleButtonType.withdraw,
                isDisabled: !((bankingAccount.balance ?? Decimal.zero) > Decimal.zero),
                onTap: () {
                  sAnalytics.eurWithdrawTapOnTheButtonWithdraw(
                    eurAccountType: isCJAccount ? 'CJ' : 'Unlimit',
                    accountIban: bankingAccount.iban ?? '',
                    accountLabel: bankingAccount.label ?? '',
                  );

                  if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.blocked)) {
                    sNotification.showError(
                      intl.operation_bloked_text,
                      id: 1,
                      needFeedback: true,
                    );

                    return;
                  }

                  showSendTimerAlertOr(
                    context: context,
                    from: [BlockingType.withdrawal],
                    or: () {
                      sAnalytics.eurWithdrawBankTransferWithEurSheet(
                        eurAccountType: isCJAccount ? 'CJ' : 'Unlimit',
                        accountIban: bankingAccount.iban ?? '',
                        accountLabel: bankingAccount.label ?? '',
                      );

                      showBankTransforSelect(context, bankingAccount, isCJAccount);
                    },
                  );
                },
              ),
              CircleActionButton(
                text: 'Exchange',
                type: CircleButtonType.exchange,
                onTap: () {
                  sNotification.showError(
                    'There is nothing we can do..',
                    id: 1,
                    needFeedback: true,
                  );
                },
              ),
              CircleActionButton(
                text: 'Settings',
                type: CircleButtonType.settings,
                onTap: () {
                  showAccountSettings(
                    context: context,
                    onChangeLableTap: onChangeLableTap,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
