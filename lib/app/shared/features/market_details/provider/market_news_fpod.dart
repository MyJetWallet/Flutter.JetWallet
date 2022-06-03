import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/market_news/model/market_news_request_model.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../notifier/market_news_notipod.dart';

const newsPortionAmount = 3;

final marketNewsInitFpod =
    FutureProvider.family.autoDispose<void, String>((ref, id) async {
  final newsService = ref.watch(marketNewsServicePod);
  final intl = ref.watch(intlPod);
  final notifier = ref.watch(marketNewsNotipod.notifier);

  final news = await newsService.marketNews(
    MarketNewsRequestModel(
      assetId: id,
      language: intl.localeName,
      lastSeen: DateTime.now().toIso8601String(),
      amount: newsPortionAmount,
    ),
  );

  notifier.updateNews(news.news);
});
