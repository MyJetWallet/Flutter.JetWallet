import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/news/model/news_request_model.dart';
import '../../../../../service/services/news/model/news_response_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../notifier/education_news_notipod.dart';

final newsInitFpod =
FutureProvider.autoDispose<List<NewsModel>>((ref) async {
  final newsService = ref.watch(newsServicePod);
  final intl = ref.watch(intlPod);
  final notifier = ref.watch(newsNotipod.notifier);
  final news = ref.watch(newsNotipod);

  if (news.news.isNotEmpty) {
    return news.news;
  } else {
    final newsResult = await newsService.news(
      NewsRequestModel(
        language: intl.localeName,
        lastSeen: DateTime.now().toIso8601String(),
        amount: news.newsPortionAmount,
      ),
    );
    notifier.updateNews(newsResult.news);
    return newsResult.news;
  }
});
