import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../shared/components/loader.dart';
import '../../../../../../screens/market/model/market_item_model.dart';
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
    final transactionsHistoryInit = useProvider(
      operationHistoryInitFpod(assetId),
    );
    final transactionHistoryN = useProvider(
      operationHistoryNotipod.notifier,
    );
    final itemsWithBalance = assetsWithBalanceFrom(useProvider(marketItemsPod));

    return transactionsHistoryInit.when(
      data: (_) {
        return RefreshIndicator(
          onRefresh: () => _refresh(
            context,
            _currentAssetFrom(itemsWithBalance),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 1.0.sh,
              width: double.infinity,
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
          ),
        );
      },
      loading: () => const Loader(),
      error: (e, _) => Text('$e'),
    );
  }

  Future<void> _refresh(BuildContext context, String assetId) {
    final transactionHistoryN = context.read(
      operationHistoryNotipod.notifier,
    );
    return transactionHistoryN.initOperationHistory(assetId);
  }

  String _currentAssetFrom(List<MarketItemModel> itemsWithBalance) =>
      itemsWithBalance[(_pageController.page ?? 0).toInt()].associateAsset;

  int _currentPage() =>
      (_pageController.hasClients ? (_pageController.page ?? 0) : 0).toInt();
}
