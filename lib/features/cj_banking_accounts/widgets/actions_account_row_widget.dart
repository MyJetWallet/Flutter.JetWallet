import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_account_deposit_by_bottom_sheet.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_account_withdraw_to_bottom_sheet.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_setting_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
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
    final handler = getIt.get<KycAlertHandler>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Observer(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SActionButton(
                icon: Assets.svg.medium.addCash.simpleSvg(
                  color: SColorsLight().white,
                ),
                lable: intl.wallet_add_cash,
                onTap: () {
                  sAnalytics.tapOnTheDepositButton(source: 'Wallet - Deposit');

                  handler.handle(
                    multiStatus: [
                      kycState.depositStatus,
                    ],
                    isProgress: kycState.verificationInProgress,
                    currentNavigate: () => showSendTimerAlertOr(
                      context: context,
                      from: [BlockingType.deposit],
                      or: () {
                        showAccountDepositBySelector(
                          context: context,
                          onClose: () {
                            sAnalytics.eurWalletTapCloseOnDeposirSheet(
                              isCJ: isCJAccount,
                              eurAccountLabel: bankingAccount.label ?? 'Account',
                              isHasTransaction: true,
                            );
                          },
                          bankingAccount: bankingAccount,
                        );
                      },
                    ),
                    requiredDocuments: kycState.requiredDocuments,
                    requiredVerifications: kycState.requiredVerifications,
                  );
                },
              ),
              SActionButton(
                lable: intl.wallet_withdraw,
                icon: Assets.svg.medium.withdrawal.simpleSvg(
                  color: SColorsLight().white,
                ),
                state: ((bankingAccount.balance ?? Decimal.zero) > Decimal.zero)
                    ? ActionButtonState.defaylt
                    : ActionButtonState.disabled,
                onTap: () {
                  handler.handle(
                    multiStatus: [
                      kycState.withdrawalStatus,
                    ],
                    isProgress: kycState.verificationInProgress,
                    currentNavigate: () => showAccountWithdrawToSelector(
                      context: context,
                      onClose: () {},
                      bankingAccount: bankingAccount,
                    ),
                    requiredDocuments: kycState.requiredDocuments,
                    requiredVerifications: kycState.requiredVerifications,
                  );
                },
              ),
              if (bankingAccount.isClearjuctionAccount)
                SActionButton(
                  lable: intl.account_actions_exchange,
                  icon: Assets.svg.medium.transfer.simpleSvg(
                    color: SColorsLight().white,
                  ),
                  state: bankingAccount.isNotEmptyBalance ? ActionButtonState.defaylt : ActionButtonState.disabled,
                  onTap: () {
                    handler.handle(
                      multiStatus: [
                        kycState.tradeStatus,
                      ],
                      isProgress: kycState.verificationInProgress,
                      currentNavigate: () => showBuyChooseAssetBottomSheet(
                        context: context,
                        onChooseAsset: (currency) {
                          sRouter.maybePop();
                          sRouter.push(
                            AmountRoute(
                              tab: AmountScreenTab.buy,
                              asset: currency,
                              account: bankingAccount,
                            ),
                          );
                        },
                      ),
                      requiredDocuments: kycState.requiredDocuments,
                      requiredVerifications: kycState.requiredVerifications,
                    );
                  },
                ),
              SActionButton(
                lable: intl.account_actions_settings,
                icon: Assets.svg.medium.settings.simpleSvg(
                  color: SColorsLight().white,
                ),
                onTap: () {
                  showAccountSettings(
                    context: context,
                    onChangeLableTap: onChangeLableTap,
                    bankingAccount: bankingAccount,
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
