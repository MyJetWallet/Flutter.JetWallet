import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../service/services/wallet/model/news/news_response_model.dart';

import '../notifier/news_notifier.dart';

final newsNotipod =
    StateNotifierProvider.autoDispose<NewsNotifier, List<NewsModel>>(
  (ref) {
    return NewsNotifier(
      read: ref.read,
    );
  },
);
