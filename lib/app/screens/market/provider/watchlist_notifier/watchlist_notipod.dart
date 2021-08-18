import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'watchlist_notifier.dart';
import 'watchlist_state.dart';

final watchlistNotipod =
    StateNotifierProvider.autoDispose<WatchlistNotifier, WatchlistState>(
  (ref) {
    return WatchlistNotifier(
      read: ref.read,
      // TODO(Vova): delete
      initialState: [],
    );
  },
);
