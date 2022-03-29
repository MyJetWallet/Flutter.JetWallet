import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'news_notifier.dart';
import 'news_state.dart';

final newsNotipod = StateNotifierProvider.autoDispose<NewsNotifier, NewsState>(
  (ref) {
    return NewsNotifier(
      read: ref.read,
    );
  },
);
