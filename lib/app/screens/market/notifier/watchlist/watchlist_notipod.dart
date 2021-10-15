import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/features/key_value/notifier/key_value_notipod.dart';
import 'watchlist_notifier.dart';

final watchlistIdsNotipod =
    StateNotifierProvider.autoDispose<WatchlistNotifier, List<String>>(
  (ref) {
    final keyValue = ref.watch(keyValueNotipod);

    final watchListIds = keyValue.watchlist?.value ?? <String>[];

    return WatchlistNotifier(
      read: ref.read,
      watchlistIds: watchListIds,
    );
  },
);
