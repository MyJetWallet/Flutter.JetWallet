import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/simple_coin_history_model.dart';

part 'simple_coin_transaction_history_store.g.dart';

class SimpleCoinTransactionHistoryStore extends _SimpleCoinTransactionHistoryStoreBase
    with _$SimpleCoinTransactionHistoryStore {
  SimpleCoinTransactionHistoryStore() : super();

  static _SimpleCoinTransactionHistoryStoreBase of(BuildContext context) =>
      Provider.of<SimpleCoinTransactionHistoryStore>(context, listen: false);
}

abstract class _SimpleCoinTransactionHistoryStoreBase with Store {
  _SimpleCoinTransactionHistoryStoreBase();

  @observable
  ObservableList<SimpleCoinHistoryItemModel> historyItems = ObservableList<SimpleCoinHistoryItemModel>.of([]);

  @observable
  int skip = 0;

  @observable
  bool hasMore = true;

  @observable
  bool isLoadingInitialData = false;

  @observable
  bool isLoadingPagination = false;

  @action
  Future<void> fetchPositionAudits({
    int take = 20,
  }) async {
    try {
      isLoadingInitialData = true;

      final response = await sNetwork.getWalletModule().postSimpleCoinHistory(
            skip: skip.toString(),
            take: take.toString(),
          );

      final items = response.data?.withdrawals ?? [];

      if (items.isNotEmpty) {
        historyItems.addAll(items);
        skip += items.length;
        isLoadingInitialData = false;
      } else {
        hasMore = false;
      }
    } catch (e) {
      hasMore = false;
    } finally {
      isLoadingInitialData = false;
    }
  }

  @action
  Future<void> loadMorePositionAudits({
    int take = 20,
  }) async {
    if (!hasMore || isLoadingPagination) return;

    try {
      if (skip == 0) {
      } else {
        isLoadingPagination = true;
      }

      final response = await sNetwork.getWalletModule().postSimpleCoinHistory(
            skip: skip.toString(),
            take: take.toString(),
          );

      final items = response.data?.withdrawals.toList() ?? [];

      if (items.isNotEmpty) {
        historyItems.addAll(items);
        skip += items.length;
      } else {
        hasMore = false;
      }
    } catch (e) {
      hasMore = false;
    } finally {
      isLoadingPagination = false;
    }
  }
}
