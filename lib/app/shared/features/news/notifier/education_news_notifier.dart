import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/news/model/news_request_model.dart';
import '../../../../../service/services/news/model/news_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'education_news_state.dart';

const newsPortion = 10;

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier({
    required this.read,
  }) : super(
          const NewsState(
            news: [],
            canLoadMore: true,
            newsPortionAmount: 10,
          ),
        );

  final Reader read;

  static final _logger = Logger('EducationNewsNotifier');

  void updateNews(List<NewsModel> news) {
    _logger.log(notifier, 'updateNews');

    if (news.isEmpty) {
      state = state.copyWith(canLoadMore: false);
    } else {
      state = state.copyWith(news: state.news + news);
    }
  }

  void updateNewsPortionAmount() {
    state = state.copyWith(
      newsPortionAmount: state.newsPortionAmount + newsPortion,
    );
  }

  Future<void> loadMoreNews() async {
    _logger.log(notifier, 'loadMoreNews');

    try {
      final news = await read(newsServicePod).news(
        NewsRequestModel(
          language: read(intlPod).localeName,
          lastSeen: state.news.last.timestamp,
          amount: state.newsPortionAmount,
        ),
      );

      if (state.news.isNotEmpty) {
        cutExistedNews(news.news);
      }

      updateNewsPortionAmount();
      updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'loadMoreNews', e);
    }
  }

  void cutExistedNews(List<NewsModel> news) {
    _logger.log(notifier, 'filteredExistedNews');

    news.removeRange(0, state.newsPortionAmount - newsPortion);
  }
}
