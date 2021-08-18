import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import 'watchlist_notipod.dart';
import 'watchlist_state.dart';

// TODO(Vova): move somewhere
const watchlistKey = 'watchlist';

final watchlistInitFpod = FutureProvider.autoDispose<void>((ref) async {
  final walletService = ref.watch(walletServicePod);
  final notifier = ref.watch(watchlistNotipod.notifier);

  final pairs = await walletService.keyValues();
  final pair = pairs.firstWhere((element) => element.key == watchlistKey);
  final items = WatchlistState.fromJson(pair as Map<String, dynamic>).items;

  notifier.updateWatchlist(items);
});
