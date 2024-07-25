import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_response_model.dart';

part 'market_news_store.g.dart';

const newsPortionAmount = 5;

class MarketNewsStore extends _MarketNewsStoreBase with _$MarketNewsStore {
  MarketNewsStore() : super();

  static _MarketNewsStoreBase of(BuildContext context) => Provider.of<MarketNewsStore>(context, listen: false);
}

abstract class _MarketNewsStoreBase with Store {
  static final _logger = Logger('NewsStore');

  String _assetId = '';

  @observable
  bool isNewsLoaded = false;

  @observable
  ObservableList<MarketNewsModel> news = ObservableList.of([]);

  @observable
  bool loadMore = true;

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingPagination = false;

  @computed
  bool get canLoadMore => news.length >= newsPortionAmount && loadMore;

  @action
  Future<void> loadMoreNews() async {
    if (isLoading || isLoadingPagination || !canLoadMore) return;

    _logger.log(notifier, 'loadMoreNews');

    try {
      isLoadingPagination = true;
      final response = await sNetwork.getWalletModule().postMarketNews(
            MarketNewsRequestModel(
              assetId: _assetId,
              language: intl.localeName,
              lastSeen: news.last.timestamp,
              amount: newsPortionAmount,
            ),
          );

      response.pick(
        onData: (data) {
          updateNews(data.news);
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'loadMoreNews', e);
      loadMore = false;
    } finally {
      isLoadingPagination = false;
    }
  }

  @action
  void updateNews(List<MarketNewsModel> newNews) {
    _logger.log(notifier, 'updateNews');

    newNews.isEmpty ? loadMore = false : news = ObservableList.of(news + newNews);
  }

  @action
  void clearNews() {
    _logger.log(notifier, 'clearNews');

    loadMore = true;
    news = ObservableList.of([]);
  }

  @action
  Future<void> loadNews(String id) async {
    if (isLoading || isLoadingPagination) return;

    try {
      _assetId = id;

      clearNews();

      isLoading = true;
      isNewsLoaded = false;

      if (id == 'CPWR') {
        isNewsLoaded = true;

        return;
      }
      final response = await sNetwork.getWalletModule().postMarketNews(
            MarketNewsRequestModel(
              assetId: id,
              language: intl.localeName,
              lastSeen: DateTime.now(),
              amount: newsPortionAmount,
            ),
          );

      response.pick(
        onData: (data) {
          updateNews(data.news);

          isNewsLoaded = true;
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'loadNews', e);
      loadMore = true;
    } finally {
      isLoading = false;
    }
  }
}
