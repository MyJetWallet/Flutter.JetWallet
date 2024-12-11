import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardTransactionHistoryRoute')
class CryptoCardTransactionHistoryScreen extends StatelessWidget {
  const CryptoCardTransactionHistoryScreen({
    super.key,
    required this.cardId,
  });

  final String cardId;

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
          ),
        ],
      ),
    );
  }
}
