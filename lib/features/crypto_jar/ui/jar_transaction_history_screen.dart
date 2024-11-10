import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'JarTransactionHistoryRouter')
class JarTransactionHistoryScreen extends StatefulWidget {
  const JarTransactionHistoryScreen({
    required this.jarId,
    required this.jarTitle,
    super.key,
  });

  final String jarId;
  final String jarTitle;

  @override
  State<JarTransactionHistoryScreen> createState() => _JarTransactionHistoryScreenState();
}

class _JarTransactionHistoryScreenState extends State<JarTransactionHistoryScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        title: intl.account_transactionHistory,
        subtitle: widget.jarTitle,
        hasRightIcon: false,
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          TransactionsList(
            scrollController: scrollController,
            jarId: widget.jarId,
            onItemTapLisener: (symbol) {},
            source: TransactionItemSource.history,
          ),
        ],
      ),
    );
  }
}
