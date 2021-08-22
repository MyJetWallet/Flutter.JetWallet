import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../service/services/news/model/news_request_model.dart';
import '../../../../service/services/news/model/news_response_model.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../provider/news_fpod.dart';

class NewsNotifier extends StateNotifier<List<NewsModel>> {
  NewsNotifier({
    required this.read,
  }) : super(
          [],
        );

  final Reader read;

  static final _logger = Logger('NewsNotifier');
  bool get isReadMore => state.length == 3;

  Future<void> loadMoreNews(String assetId) async {
    _logger.log(notifier, 'loadMoreNews');

    try {
      final news = await read(newsServicePod).news(
        NewsRequestModel(
          assetId: assetId,
          language: read(intlPod).localeName,
          lastSeen: DateTime.now().toIso8601String(),
          amount: state.length + newsPortionAmount,
        ),
      );

      updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'loadMoreNews', e);
    }
  }

  void cutNewToDefaultSize() {
    _logger.log(notifier, 'cutNewToDefaultSize');

    state = state.sublist(0, newsPortionAmount);
  }

  void updateNews(List<NewsModel> news) {
    _logger.log(notifier, 'updateNews');

    state = news;
  }
}
