import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../service/services/news/model/news_request_model.dart';
import '../../../../service/services/news/model/news_response_model.dart';
import 'news_state.dart';
import 'news_union.dart';

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier({
    required this.read,
    required this.assetId,
  }) : super(
    const NewsState(
      newsItems: [],
    ),
  );

  final Reader read;
  final String? assetId;

  static final _logger = Logger('NewsNotifier');

  Future<void> initNews() async {
    _logger.log(notifier, 'initNews');
    print('RETRY2|| ');

    try {
      final news = await _requestNews(
        NewsRequestModel(
          assetId: assetId,
          batchSize: 20,
          language: read(intlPod).localeName,
        ),
      );

      print('RETRY2|| $news');

      _updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'initNews', e);

      read(sNotificationNotipod.notifier).showError(
        'Something went wrong',
        id: 1,
      );

      state = state.copyWith(union: const Error());
    }
  }

  Future<void> news(String? assetId) async {
    _logger.log(notifier, 'operationHistory');

    try {
      final news = await _requestNews(
        NewsRequestModel(
          assetId: assetId,
          batchSize: 20,
          lastDate: state.newsItems.last.timestamp,
          language: read(intlPod).localeName,
        ),
      );

      print('COMES NEWS|| ${news}');

      _updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'news', e);

      print('ERRROROR|| ${news}');

      read(sNotificationNotipod.notifier).showError(
        'Something went wrong',
        id: 2,
      );

      state = state.copyWith(union: const Error());
    }
  }

  void _updateNews(List<NewsModel> items) {

    print('_updateNews|| ${items}');

    if (items.isEmpty) {
      state = state.copyWith(
        nothingToLoad: true,
        union: const Loaded(),
      );
    } else {

      print('Before set state ||| $items');

      state = state.copyWith(
        newsItems: items,
        union: const Loaded(),
      );


      print('state set ||| ${state.newsItems}');

    }
  }

  Future<NewsResponseModel> _requestNews(
      NewsRequestModel model,
      ) {
    state = state.copyWith(union: const Loading());

    return read(newsServicePod).news(
      model,
    );
  }
}
