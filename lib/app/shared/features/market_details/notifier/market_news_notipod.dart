import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'market_news_notifier.dart';
import 'market_news_state.dart';

final marketNewsNotipod =
    StateNotifierProvider.autoDispose<MarketNewsNotifier, MarketNewsState>(
  (ref) {
    return MarketNewsNotifier(
      read: ref.read,
    );
  },
);
