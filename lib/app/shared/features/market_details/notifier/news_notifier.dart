import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/news/model/news_request_model.dart';
import '../../../../../service/services/news/model/news_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../provider/news_fpod.dart';
import 'news_state.dart';

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier({
    required this.read,
  }) : super(
          const NewsState(
            news: [],
            canLoadMore: true,
          ),
        );

  final Reader read;

  static final _logger = Logger('NewsNotifier');

  bool get canLoadMore => state.news.length >= 3 && state.canLoadMore;

  Future<void> loadMoreNews(String assetId) async {
    _logger.log(notifier, 'loadMoreNews');

    try {
      final news = await read(newsServicePod).news(
        NewsRequestModel(
          assetId: assetId,
          language: read(intlPod).localeName,
          lastSeen: state.news.last.timestamp,
          amount: newsPortionAmount,
        ),
      );

      updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'loadMoreNews', e);
    }
  }

  void cutNewToDefaultSize() {
    _logger.log(notifier, 'cutNewToDefaultSize');

    state = state.copyWith(
      news: state.news.sublist(0, newsPortionAmount),
    );
  }

  void updateNews(List<NewsModel> news) {
    _logger.log(notifier, 'updateNews');

    if (news.isEmpty) {
      state = state.copyWith(canLoadMore: false);
    } else {
      state = state.copyWith(news: state.news + news);
    }
  }
}
