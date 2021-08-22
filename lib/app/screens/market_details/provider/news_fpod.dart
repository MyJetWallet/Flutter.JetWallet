import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/news/model/news_request_model.dart';
import '../../../../shared/providers/service_providers.dart';
import 'news_notipod.dart';

const newsPortionAmount = 3;

final newsInitFpod =
    FutureProvider.family.autoDispose<void, String>((ref, id) async {
  final newsService = ref.watch(newsServicePod);
  final intl = ref.watch(intlPod);
  final notifier = ref.watch(newsNotipod.notifier);

  final news = await newsService.news(
    NewsRequestModel(
      assetId: id,
      language: intl.localeName,
      lastSeen: DateTime.now().toIso8601String(),
      amount: newsPortionAmount,
    ),
  );

  notifier.updateNews(news.news);
});
