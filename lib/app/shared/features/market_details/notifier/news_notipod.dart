import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../service/services/news/model/news_response_model.dart';

import 'news_notifier.dart';

final newsNotipod =
    StateNotifierProvider.autoDispose<NewsNotifier, List<NewsModel>>(
  (ref) {
    return NewsNotifier(
      read: ref.read,
    );
  },
);
