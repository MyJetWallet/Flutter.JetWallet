import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/news/model/news_request_model.dart';
import '../../../../../service/services/news/model/news_response_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../notifier/education_news_notipod.dart';

final newsInitFpod =
FutureProvider.autoDispose<List<NewsModel>>((ref) async {
  final newsService = ref.read(newsServicePod);
  final intl = ref.read(intlPod);
  final notifier = ref.read(newsNotipod.notifier);
  final educationNews = ref.read(newsNotipod);

  if (educationNews.news.isNotEmpty) {
    return educationNews.news;
  } else {
    final news = await newsService.news(
      NewsRequestModel(
        language: intl.localeName,
        lastSeen: DateTime.now().toIso8601String(),
        amount: educationNews.newsPortionAmount,
      ),
    );
    notifier.updateNews(news.news);
    return news.news;
  }
});
