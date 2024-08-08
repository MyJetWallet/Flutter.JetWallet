import 'package:flutter/material.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_loading_item.dart';
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
          TransactionListLoadingItem(
            opacity: 1,
            fromMarket: true,
          ),
          TransactionListLoadingItem(
            opacity: 0.8,
            fromMarket: true,
          ),
          TransactionListLoadingItem(
            opacity: 0.6,
            fromMarket: true,
          ),
          TransactionListLoadingItem(
            opacity: 0.4,
            fromMarket: true,
          ),
          TransactionListLoadingItem(
            opacity: 0.2,
            removeDivider: true,
            fromMarket: true,
          ),
        ],
      ),
    );
  }
}
