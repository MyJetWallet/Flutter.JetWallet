import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../wallet/helper/nft_types.dart';
import '../../wallet/ui/widgets/wallet_body/widgets/transactions_list/transactions_main_list.dart';

@RoutePage(name: 'TransactionHistoryRouter')
class TransactionHistory extends StatefulObserverWidget {
  const TransactionHistory({
    super.key,
    this.assetName,
    this.assetSymbol,
    this.initialIndex = 0,
    this.jwOperationId,
    this.onTabChanged,
  });

  final String? assetName;
  final String? assetSymbol;
  final int initialIndex;
  final String? jwOperationId;
  final void Function(int index)? onTabChanged;

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    sAnalytics.globalTransactionHistoryScreenView(
      globalHistoryTab: widget.initialIndex == 0 ? GlobalHistoryTab.all : GlobalHistoryTab.pending,
    );
    _tabController = TabController(
      initialIndex: widget.initialIndex,
      length: 2,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 0) {
        sAnalytics.tapOnTheButtonAllOnGlobalTransactionHistoryScreen(
          globalHistoryTab: GlobalHistoryTab.all,
        );
      } else {
        sAnalytics.tapOnTheButtonPendingOnGlobalTransactionHistoryScreen(
          globalHistoryTab: GlobalHistoryTab.pending,
        );
      }
      widget.onTabChanged?.call(_tabController.index);
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: _title(context, TransactionType.none),
          onBackButtonTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          SPaddingH24(
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                labelColor: colors.white,
                labelStyle: sSubtitle3Style,
                unselectedLabelColor: colors.grey1,
                unselectedLabelStyle: sSubtitle3Style,
                splashBorderRadius: BorderRadius.circular(16),
                tabs: [
                  Tab(
                    text: intl.transaction_tab_all,
                  ),
                  Tab(
                    text: intl.transaction_tab_pending,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: colors.white,
            height: 16,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TransactionsMainList(
                  zeroPadding: true,
                  symbol: widget.assetSymbol,
                  jwOperationId: widget.jwOperationId,
                ),
                TransactionsMainList(
                  zeroPadding: true,
                  symbol: widget.assetSymbol,
                  jwOperationId: widget.jwOperationId,
                  pendingOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context, TransactionType type) {
    return intl.account_transactionHistory;
  }
}
