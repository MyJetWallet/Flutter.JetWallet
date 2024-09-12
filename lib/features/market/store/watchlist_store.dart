import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';

part 'watchlist_store.g.dart';

class WatchlistStore extends _WatchlistStoreBase with _$WatchlistStore {
  WatchlistStore() : super();

  static _WatchlistStoreBase of(BuildContext context) => Provider.of<WatchlistStore>(context, listen: false);
}

abstract class _WatchlistStoreBase with Store {
  _WatchlistStoreBase() {
    watchListIds = ObservableList.of(sSignalRModules.keyValue.watchlist?.value ?? <String>[]);
    state = ObservableList.of(watchListIds);
  }

  @observable
  ObservableList<String> watchListIds = ObservableList.of([]);

  @computed
  ObservableList<MarketItemModel> get watchListMarketItems {
    final ids = state;
    final output = ObservableList<MarketItemModel>.of([]);

    final assets = sSignalRModules.marketItems;

    for (var i = 0; i < ids.length; i++) {
      final obj = assets.indexWhere((element) => element.symbol == ids[i]);
      if (obj != -1) {
        output.add(assets[obj]);
      }
    }

    return output;
  }

  static final _logger = Logger('WatchlistStore');

  @observable
  ObservableList<String> state = ObservableList.of([]);

  @action
  Future<void> addToWatchlist(String assetId) async {
    _logger.log(notifier, 'addToWatchlist');

    try {
      final set = Set.of(state);
      set.add(assetId);
      state = ObservableList.of(set);

      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: watchlistKey,
                  value: jsonEncode(state),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'addToWatchlist', e);
    }
  }

  @action
  Future<void> removeFromWatchlist(String assetId) async {
    _logger.log(notifier, 'removeFromWatchlist');

    try {
      final list = List.of(state);
      list.remove(assetId);
      state = ObservableList.of(list);

      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: watchlistKey,
                  value: jsonEncode(state),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'removeFromWatchlist', e);
    }
  }

  @action
  Future<void> changePosition(
    int oldIndex,
    int newIndex,
  ) async {
    _logger.log(notifier, 'changePosition');

    final list = List.of(state);

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    state = ObservableList.of(list);

    try {
      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: watchlistKey,
                  value: jsonEncode(state),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'changePosition', e);
    }
  }

  @action
  bool isInWatchlist(String assetId) => state.contains(assetId);
}
