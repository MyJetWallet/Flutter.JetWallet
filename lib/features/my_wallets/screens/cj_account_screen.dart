import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/my_wallets/helper/show_deposit_details_popup.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_button.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';

@RoutePage(name: 'CJAccountRouter')
class CJAccountScreen extends StatefulObserverWidget {
  const CJAccountScreen({
    super.key,
    required this.bankingAccount,
    required this.isCJAccount,
  });

  final SimpleBankingAccount bankingAccount;
  final bool isCJAccount;

  @override
  State<CJAccountScreen> createState() => _CJAccountScreenState();
}

class _CJAccountScreenState extends State<CJAccountScreen> {
  late ScrollController _controller;
  final ScrollController _transactionScrollController = ScrollController();
  bool silverCollapsed = false;

  String label = '';

  @override
  void initState() {
    super.initState();

    label = widget.bankingAccount.label ?? 'Account';

    sAnalytics.eurWalletEURAccountWallet(
      isCJ: widget.isCJAccount,
      eurAccountLabel: widget.bankingAccount.label ?? 'Account',
      isHasTransaction: true,
    );

    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final kycState = getIt.get<KycService>();

    return SPageFrame(
      loaderText: '',
      child: Column(
        children: [
          CollapsedAccountAppbar(
            mainBlockCenter: true,
            scrollController: _controller,
            showTicker: false,
            mainTitle: volumeFormat(
              decimal: widget.bankingAccount.balance ?? Decimal.zero,
              accuracy: eurCurrency.accuracy,
              symbol: eurCurrency.symbol,
            ),
            mainHeaderTitle: label,
            mainHeaderSubtitle: widget.isCJAccount ? intl.wallet_simple_account : intl.eur_wallet_personal_account,
            mainHeaderCollapsedTitle: volumeFormat(
              decimal: widget.bankingAccount.balance ?? Decimal.zero,
              accuracy: eurCurrency.accuracy,
              symbol: eurCurrency.symbol,
            ),
            mainHeaderCollapsedSubtitle:
                widget.isCJAccount ? intl.wallet_simple_account : intl.eur_wallet_personal_account,
            onRightIconTap: () {
              sAnalytics.eurWalletTapEditEURAccointScreen(
                isCJ: widget.isCJAccount,
                eurAccountLabel: widget.bankingAccount.label ?? 'Account',
                isHasTransaction: true,
              );

              sAnalytics.eurWalletEditLabelScreen();

              sRouter
                  .push(
                CJAccountLabelRouter(
                  initLabel: label,
                  accountId: widget.bankingAccount.accountId ?? '',
                ),
              )
                  .then((value) {
                if (value != null) {
                  try {
                    setState(() {
                      label = value as String;
                    });
                  } catch (e) {
                    log(e.toString());
                  }
                }
              });
            },
          ),
          Expanded(
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                if (!silverCollapsed)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleActionButton(
                              text: intl.wallet_add_cash,
                              type: CircleButtonType.addCash,
                              isExpanded: false,
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
                                      isCJ: widget.isCJAccount,
                                      eurAccountLabel: widget.bankingAccount.label ?? 'Account',
                                      isHasTransaction: true,
                                    );

                                    sAnalytics.eurWalletDepositDetailsSheet(
                                      isCJ: widget.isCJAccount,
                                      eurAccountLabel: widget.bankingAccount.label ?? 'Account',
                                      isHasTransaction: true,
                                      source: 'EUR wallet',
                                    );

                                    showDepositDetails(
                                      context,
                                      () {
                                        sAnalytics.eurWalletTapCloseOnDeposirSheet(
                                          isCJ: widget.isCJAccount,
                                          eurAccountLabel: widget.bankingAccount.label ?? 'Account',
                                          isHasTransaction: true,
                                        );
                                      },
                                      widget.isCJAccount,
                                      widget.bankingAccount,
                                    );
                                  },
                                );
                              },
                            ),
                            const SpaceW8(),
                            CircleActionButton(
                              text: intl.wallet_withdraw,
                              type: CircleButtonType.withdraw,
                              isExpanded: false,
                              isDisabled: !((widget.bankingAccount.balance ?? Decimal.zero) > Decimal.zero),
                              onTap: () {
                                sAnalytics.eurWithdrawTapOnTheButtonWithdraw(
                                  eurAccountType: widget.isCJAccount ? 'CJ' : 'Unlimit',
                                  accountIban: widget.bankingAccount.iban ?? '',
                                  accountLabel: widget.bankingAccount.label ?? '',
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
                                      eurAccountType: widget.isCJAccount ? 'CJ' : 'Unlimit',
                                      accountIban: widget.bankingAccount.iban ?? '',
                                      accountLabel: widget.bankingAccount.label ?? '',
                                    );

                                    showBankTransforSelect(context, widget.bankingAccount, widget.isCJAccount);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: STableHeader(
                    size: SHeaderSize.m,
                    title: intl.wallet_transactions,
                  ),
                ),
                TransactionsList(
                  scrollController: _transactionScrollController,
                  symbol: 'EUR',
                  fromCJAccount: true,
                  accountId: widget.bankingAccount.accountId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
