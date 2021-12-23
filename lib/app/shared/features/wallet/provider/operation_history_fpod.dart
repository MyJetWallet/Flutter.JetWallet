import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/market/provider/market_items_pod.dart';
import '../helper/assets_with_balance_from.dart';
import '../notifier/operation_history_notipod.dart';

final operationHistoryInitFpod =
    FutureProvider.family.autoDispose<void, String>((ref, assetId) async {
  // final operationHistoryService = ref.watch(operationHistoryServicePod);
  // final notifier = ref.watch(operationHistoryNotipod.notifier);

  final transactionHistoryN = ref.read(
    operationHistoryNotipod.notifier,
  );
  final itemsWithBalance = marketItemsWithBalanceFrom(
    ref.read(marketItemsPod),
    'ETH',
  );

  for (final item in itemsWithBalance) {
    await transactionHistoryN.initOperationHistory(
      item.associateAsset,
    );
  }

  // final operationHistory = await operationHistoryService.operationHistory(
  //   OperationHistoryRequestModel(
  //     assetId: assetId,
  //     batchSize: 20,
  //   ),
  // );
  //
  // notifier.updateOperationHistory(operationHistory.operationHistory);
});
