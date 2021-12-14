import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/loaders/loader.dart';
import '../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../helper/assets_with_balance_from.dart';
import '../../../notifier/operation_history_notipod.dart';
import '../../../provider/operation_history_fpod.dart';
import 'components/wallet_body.dart';

class Wallets extends HookWidget {
  Wallets({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final transactionsHistoryInit = useProvider(
      operationHistoryInitFpod(assetId),
    );
    final transactionHistoryN = useProvider(
      operationHistoryNotipod.notifier,
    );
    final itemsWithBalance = marketItemsWithBalanceFrom(
      useProvider(marketItemsPod),
      assetId,
    );

    return transactionsHistoryInit.when(
      data: (_) {
        return SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                transactionHistoryN.initOperationHistory(
                  itemsWithBalance[index].associateAsset,
                );
              },
              children: [
                for (final item in itemsWithBalance)
                  WalletBody(
                    assetId: item.associateAsset,
                    currentPage: _currentPage(),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Loader(),
      error: (e, _) => Text('$e'),
    );
  }

  int _currentPage() =>
      (_pageController.hasClients ? (_pageController.page ?? 0) : 0).toInt();
}
