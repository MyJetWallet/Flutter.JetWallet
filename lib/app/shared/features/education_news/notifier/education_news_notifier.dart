import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/education_news/model/education_news_request_model.dart';
import '../../../../../service/services/education_news/model/education_news_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'education_news_state.dart';

const newsPortion = 10;

class EducationNewsNotifier extends StateNotifier<EducationNewsState> {
  EducationNewsNotifier({
    required this.read,
  }) : super(
          const EducationNewsState(
            news: [],
            canLoadMore: true,
            newsPortionAmount: 10,
          ),
        );

  final Reader read;

  static final _logger = Logger('EducationNewsNotifier');

  void updateNews(List<EducationNewsModel> news) {
    _logger.log(notifier, 'updateNews');

    if (news.isEmpty) {
      state = state.copyWith(canLoadMore: false);
    } else {
      state = state.copyWith(news: state.news + news);
    }
  }

  void updateTakeNews() {
    state = state.copyWith(
      newsPortionAmount: state.newsPortionAmount + newsPortion,
    );
  }

  Future<void> loadMoreNews() async {
    _logger.log(notifier, 'loadMoreNews');

    try {
      final news = await read(educationNewsServicePod).educationNews(
        EducationNewsRequestModel(
          language: read(intlPod).localeName,
          lastSeen: state.news.last.timestamp,
          amount: state.newsPortionAmount,
        ),
      );

      updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'loadMoreNews', e);
    }
  }
}
