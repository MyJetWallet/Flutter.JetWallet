import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/actions_account_row_widget.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../core/di/di.dart';
import '../../../utils/models/currency_model.dart';
import '../../app/store/app_store.dart';

@RoutePage(name: 'CJAccountRouter')
class CJAccountScreen extends StatefulObserverWidget {
  const CJAccountScreen({
    super.key,
    required this.bankingAccount,
    required this.isCJAccount,
    required this.eurCurrency,
  });

  final SimpleBankingAccount bankingAccount;
  final bool isCJAccount;
  final CurrencyModel eurCurrency;

  @override
  State<CJAccountScreen> createState() => _CJAccountScreenState();
}

class _CJAccountScreenState extends State<CJAccountScreen> {
  late ScrollController _controller;
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
    return SPageFrame(
      loaderText: '',
      child: Column(
        children: [
          CollapsedAccountAppbar(
            mainBlockCenter: true,
            scrollController: _controller,
            showTicker: false,
            mainTitle: getIt<AppStore>().isBalanceHide
                ? '**** ${widget.eurCurrency.symbol}'
                : (widget.bankingAccount.balance ?? Decimal.zero).toFormatSum(
                    accuracy: widget.eurCurrency.accuracy,
                    symbol: widget.eurCurrency.symbol,
                  ),
            mainHeaderTitle: label,
            mainHeaderSubtitle: widget.isCJAccount ? intl.wallet_simple_account : intl.eur_wallet_personal_account,
            mainHeaderCollapsedTitle: getIt<AppStore>().isBalanceHide
                ? '**** ${widget.eurCurrency.symbol}'
                : (widget.bankingAccount.balance ?? Decimal.zero).toFormatSum(
                    accuracy: widget.eurCurrency.accuracy,
                    symbol: widget.eurCurrency.symbol,
                  ),
            mainHeaderCollapsedSubtitle:
                widget.isCJAccount ? intl.wallet_simple_account : intl.eur_wallet_personal_account,
            hasRightIcon: false,
          ),
          Expanded(
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                if (!silverCollapsed)
                  SliverToBoxAdapter(
                    child: ActionsAccountRowWidget(
                      bankingAccount: widget.bankingAccount.copyWith(
                        label: label,
                      ),
                      onChangeLableTap: () {
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
                  ),
                SliverToBoxAdapter(
                  child: STableHeader(
                    size: SHeaderSize.m,
                    title: intl.wallet_transactions,
                  ),
                ),
                TransactionsList(
                  scrollController: _controller,
                  symbol: 'EUR',
                  fromCJAccount: true,
                  accountId: widget.bankingAccount.accountId,
                  source: TransactionItemSource.eurAccount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
