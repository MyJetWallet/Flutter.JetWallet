import 'package:flutter/material.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_loading_item.dart';

class EarnDetailsSkeleton extends StatelessWidget {
  const EarnDetailsSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          TransactionListLoadingItem(
            opacity: 1,
          ),
          TransactionListLoadingItem(
            opacity: 0.8,
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
        ],
      ),
    );
  }
}
