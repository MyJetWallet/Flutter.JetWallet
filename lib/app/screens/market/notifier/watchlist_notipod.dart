import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';

import 'watchlist_notifier.dart';

final watchlistNotipod =
    StateNotifierProvider.autoDispose<WatchlistNotifier, List<String>>(
  (ref) {
    final keyValue = ref.watch(keyValueNotipod);

    final watchList =
        keyValue.watchlist != null ? keyValue.watchlist!.value : <String>[];

    return WatchlistNotifier(
      read: ref.read,
      watchlist: watchList,
    );
  },
);
