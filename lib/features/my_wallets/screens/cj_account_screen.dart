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
import 'package:jetwallet/features/my_wallets/widgets/cj_header_widget.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_list.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/widgets/circle_action_buttons/circle_action_button.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
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

    _controller.addListener(() {
      if (_controller.offset > 170 && !_controller.position.outOfRange) {
        if (!silverCollapsed) {
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_controller.offset <= 170 && !_controller.position.outOfRange) {
        if (silverCollapsed) {
          silverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final kycState = getIt.get<KycService>();

    return SPageFrame(
      loaderText: '',
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            expandedHeight: 226,
            floating: true,
            pinned: true,
            backgroundColor: sKit.colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            leadingWidth: 48,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: SIconButton(
                onTap: () {
                  Navigator.pop(context);
                },
                defaultIcon: const SBackIcon(),
                pressedIcon: const SBackPressedIcon(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SIconButton(
                  onTap: () {
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
                  defaultIcon: const SEditIcon(),
                  pressedIcon: SEditIcon(color: sKit.colors.grey1),
                ),
              ),
            ],
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (silverCollapsed) const SizedBox(height: 10),
                if (!silverCollapsed)
                  Text(
                    label,
                    style: sTextH5Style.copyWith(
                      color: sKit.colors.black,
                    ),
                  ),
                Text(
                  widget.isCJAccount ? intl.wallet_simple_account : intl.eur_wallet_personal_account,
                  style: sBodyText2Style.copyWith(
                    color: sKit.colors.grey1,
                  ),
                ),
              ],
            ),
            flexibleSpace: CJHeaderWidget(
              eurCurr: eurCurrency,
              bankingAccount: widget.bankingAccount,
            ),
          ),
          if (!silverCollapsed)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 28,
                ),
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
                              duration: 4,
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
                          if (kycState.withdrawalStatus == kycOperationStatus(KycStatus.blocked)) {
                            sNotification.showError(
                              intl.operation_bloked_text,
                              duration: 4,
                              id: 1,
                              needFeedback: true,
                            );

                            return;
                          }

                          showSendTimerAlertOr(
                            context: context,
                            from: [BlockingType.withdrawal],
                            or: () {
                              showBankTransforSelect(context, widget.bankingAccount, widget.isCJAccount);

                              sAnalytics.eurWalletWithdrawEURAccountScreen(
                                isCJ: widget.isCJAccount,
                                eurAccountLabel: widget.bankingAccount.label ?? 'Account',
                                isHasTransaction: true,
                                copyType: '',
                              );
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
            child: SPaddingH24(
              child: Text(
                intl.wallet_transactions,
                style: sTextH4Style,
              ),
            ),
          ),
          if (eurCurrency.isAssetBalanceNotEmpty) ...[
            TransactionsList(
              scrollController: _transactionScrollController,
              symbol: 'EUR',
              fromCJAccount: true,
              accountId: widget.bankingAccount.accountId,
            ),
          ] else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      smileAsset,
                      width: 48,
                      height: 48,
                    ),
                    Text(
                      intl.wallet_simple_account_empty,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: sSubtitle2Style.copyWith(
                        color: sKit.colors.grey2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
