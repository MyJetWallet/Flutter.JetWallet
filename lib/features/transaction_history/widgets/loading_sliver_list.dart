import 'package:flutter/material.dart';

import 'transaction_list_loading_item.dart';

class LoadingSliverList extends StatelessWidget {
  const LoadingSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        TransactionListLoadingItem(
          opacity: 1,
        ),
        TransactionListLoadingItem(
          opacity: 0.8,
        ),
        TransactionListLoadingItem(
          opacity: 0.6,
        ),
        TransactionListLoadingItem(
          opacity: 0.4,
        ),
        TransactionListLoadingItem(
          opacity: 0.2,
          removeDivider: true,
        ),
      ]),
    );
  }
}
