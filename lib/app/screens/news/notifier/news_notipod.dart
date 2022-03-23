import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'news_notifier.dart';
import 'news_state.dart';

final newsNotipod =
    StateNotifierProvider.autoDispose.family<NewsNotifier, NewsState, String?>(
  (ref, assetId) {
    return NewsNotifier(
      read: ref.read,
      assetId: assetId,
    );
  },
);
