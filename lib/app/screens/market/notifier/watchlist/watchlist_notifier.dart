import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/key_value/model/key_value_request_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_response_model.dart';

import '../../../../../shared/constants.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../shared/features/key_value/notifier/key_value_notipod.dart';

class WatchlistNotifier extends StateNotifier<List<String>> {
  WatchlistNotifier({
    required this.read,
    required this.watchlistIds,
  }) : super([]) {
    state = watchlistIds;
  }

  final Reader read;
  final List<String> watchlistIds;

  static final _logger = Logger('WatchlistNotifier');

  Future<void> addToWatchlist(String assetId) async {
    _logger.log(notifier, 'addToWatchlist');

    try {
      final set = Set.of(state);
      set.add(assetId);
      state = set.toList();

      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: watchlistKey,
              value: jsonEncode(state),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'addToWatchlist', e);
    }
  }

  Future<void> removeFromWatchlist(String assetId) async {
    _logger.log(notifier, 'removeFromWatchlist');

    try {
      final list = List.of(state);
      list.remove(assetId);
      state = list;

      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: watchlistKey,
              value: jsonEncode(state),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'removeFromWatchlist', e);
    }
  }

  Future<void> changePosition(
    int oldIndex,
    int newIndex,
  ) async {
    _logger.log(notifier, 'changePosition');

    final list = List.of(state);

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    state = list;

    try {
      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: watchlistKey,
              value: jsonEncode(state),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'changePosition', e);
    }
  }

  bool isInWatchlist(String assetId) => state.contains(assetId);
}
