import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/education_news/model/education_news_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../notifier/education_news_notipod.dart';

final educationNewsInitFpod =
FutureProvider.autoDispose<void>((ref) async {
  final educationNewsService = ref.read(educationNewsServicePod);
  final intl = ref.read(intlPod);
  final notifier = ref.read(educationNewsNotipod.notifier);
  final educationNews = ref.read(educationNewsNotipod);

  final news = await educationNewsService.educationNews(
    EducationNewsRequestModel(
      language: intl.localeName,
      lastSeen: DateTime.now().toIso8601String(),
      amount: educationNews.newsPortionAmount,
    ),
  );

  notifier.updateNews(news.news);
});
