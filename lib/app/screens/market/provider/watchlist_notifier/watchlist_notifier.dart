import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/wallet/model/key_value/key_value_request_model.dart';
import '../../../../../service/services/wallet/model/key_value/key_value_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../model/market_item_model.dart';
import 'watchlist_fpod.dart';
import 'watchlist_state.dart';

class WatchlistNotifier extends StateNotifier<WatchlistState> {
  WatchlistNotifier({
    required this.read,
    required this.initialState,
  }) : super(
          WatchlistState(
            items: initialState,
          ),
        );

  final Reader read;
  final List<MarketItemModel> initialState;

  Future<void> addToWatchlist(MarketItemModel item) async {
    _logger.log(notifier, 'addToWatchlist');

    final items = state.items;
    items.add(item);
    state = state.copyWith(items: items);

    try {
      await read(walletServicePod).keyValueSet(
        KeyValueRequestModel(keys: [
          KeyValueResponseModel(
            key: watchlistKey,
            value: state.toJson().toString(),
          )
        ]),
      );

    } catch (e) {
      _logger.log(notifier, 'addToWatchlist', e);
    }
  }

  void updateWatchlist(List<MarketItemModel> items) {
    _logger.log(notifier, 'updateWatchlist');

    state = state.copyWith(
      items: items,
    );
  }

  static final _logger = Logger('WatchlistNotifier');
}
