import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/market_news/model/market_news_request_model.dart';
import '../../../../../service/services/market_news/model/market_news_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../provider/market_news_fpod.dart';
import 'market_news_state.dart';

class MarketNewsNotifier extends StateNotifier<MarketNewsState> {
  MarketNewsNotifier({
    required this.read,
  }) : super(
          const MarketNewsState(
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
      final news = await read(marketNewsServicePod).marketNews(
        MarketNewsRequestModel(
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

  void updateNews(List<MarketNewsModel> news) {
    _logger.log(notifier, 'updateNews');

    if (news.isEmpty) {
      state = state.copyWith(canLoadMore: false);
    } else {
      state = state.copyWith(news: state.news + news);
    }
  }
}
