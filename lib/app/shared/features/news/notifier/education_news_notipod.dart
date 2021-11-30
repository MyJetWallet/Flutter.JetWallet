import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'education_news_notifier.dart';
import 'education_news_state.dart';

final newsNotipod =
StateNotifierProvider<NewsNotifier, NewsState>(
      (ref) {
    return NewsNotifier(
      read: ref.read,
    );
  },
);
