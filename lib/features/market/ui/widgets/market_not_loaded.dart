import 'package:flutter/material.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_loading_item.dart';
import 'package:simple_kit/simple_kit.dart';

class MarketNotLoaded extends StatelessWidget {
  const MarketNotLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.white,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SPaddingH24(
            child: SSkeletonTextLoader(
              height: 120,
              width: 327,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          TransactionListLoadingItem(
            opacity: 1,
          ),
          TransactionListLoadingItem(
            opacity: 0.6,
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
