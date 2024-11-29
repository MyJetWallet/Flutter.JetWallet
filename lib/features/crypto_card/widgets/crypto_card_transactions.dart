import 'package:flutter/material.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transactions_list.dart';

class CryptoCardTransactions extends StatelessWidget {
  const CryptoCardTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      slivers : [
        TransactionsList(
          scrollController: ScrollController(),
          symbol: '_DEBUG_',
          onItemTapLisener: (symbol) {},
          source: TransactionItemSource.history,
          mode: TransactionListMode.preview,
          onData: (items) {
            // if (items.where((item) => item.status == ohrm.Status.inProgress).isNotEmpty) {
            //   if (allowCloseByTransactions) {
            //     setState(() {
            //       allowCloseByTransactions = false;
            //     });
            //   }
            // } else {
            //   if (!allowCloseByTransactions) {
            //     setState(() {
            //       allowCloseByTransactions = true;
            //     });
            //   }
            // }
            //
            // if (items.length >= 5) {
            //   if (!showViewAllButtonOnHistory) {
            //     setState(() {
            //       showViewAllButtonOnHistory = true;
            //     });
            //   }
            // }
          },
        ),
      ],
    );
  }
}
