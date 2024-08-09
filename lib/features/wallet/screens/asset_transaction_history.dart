import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'AssetTransactionHistoryRouter')
class AssetTransactionHistoryScreen extends StatefulWidget {
  const AssetTransactionHistoryScreen({super.key, required this.assetId});

  final String assetId;

  @override
  State<AssetTransactionHistoryScreen> createState() => _AssetTransactionHistoryScreenState();
}

class _AssetTransactionHistoryScreenState extends State<AssetTransactionHistoryScreen> {
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
        subtitle: widget.assetId,
        hasRightIcon: false,
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          TransactionsList(
            scrollController: scrollController,
            symbol: widget.assetId,
            onItemTapLisener: (symbol) {},
            source: TransactionItemSource.cryptoAccount,
          ),
        ],
      ),
    );
  }
}
