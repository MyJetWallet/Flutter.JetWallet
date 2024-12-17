import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';

@RoutePage(name: 'CryptoCardTransactionHistoryRoute')
class CryptoCardTransactionHistoryScreen extends StatelessWidget {
  const CryptoCardTransactionHistoryScreen({
    super.key,
    required this.cardId,
    this.operationId,
  });

  final String cardId;
  final String? operationId;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        hasRightIcon: false,
        title: intl.crypto_card_history_transaction_history,
        subtitle: intl.crypto_card_main_title,
      ),
      child: CustomScrollView(
        slivers: [
          TransactionsList(
            scrollController: ScrollController(),
            symbol: '_DEBUG_',
            onItemTapLisener: (symbol) {},
            source: TransactionItemSource.cryptoCard,
            jwOperationId: operationId,
          ),
        ],
      ),
    );
  }
}
