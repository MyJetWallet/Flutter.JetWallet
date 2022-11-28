import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/news/models/news_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/news/news_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/news/news_response_model.dart';

part 'news_store.g.dart';

class NewsStore extends _NewsStoreBase with _$NewsStore {
  NewsStore() : super();

  static _NewsStoreBase of(BuildContext context) =>
      Provider.of<NewsStore>(context, listen: false);
}

abstract class _NewsStoreBase with Store {
  _NewsStoreBase() {
    init(null);
  }

  static final _logger = Logger('NewsStore');

  @observable
  NewsUnion union = const NewsUnion.loading();

  @observable
  bool nothingToLoad = false;

  @observable
  ObservableList<NewsModel> newsItems = ObservableList.of([]);

  @action
  Future<void> init(ScrollController? scrollController) async {
    try {
      final news = await _requestNews(
        NewsRequestModel(
          batchSize: 20,
          language: intl.localeName,
        ),
      );

      _updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'init', e);

      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );

      _scrollDown(scrollController);

      union = const NewsUnion.error();
    }
  }

  @action
  Future<void> news(ScrollController? scrollController) async {
    _logger.log(notifier, 'news');

    try {
      final news = await _requestNews(
        NewsRequestModel(
          batchSize: 20,
          lastDate: newsItems.last.timestamp,
          language: intl.localeName,
        ),
      );

      _updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'news', e);

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );

      _scrollDown(scrollController);

      union = const NewsUnion.error();
    }
  }

  @action
  void _updateNews(List<NewsModel> items) {
    if (items.isEmpty) {
      nothingToLoad = true;
      union = const NewsUnion.loaded();
    } else {
      newsItems = ObservableList.of(newsItems + items);
      union = const NewsUnion.loaded();
    }
  }

  @action
  Future<NewsResponseModel> _requestNews(
    NewsRequestModel model,
  ) async {
    union = const NewsUnion.loading();

    final response = await sNetwork.getWalletModule().postNews(model);

    return response.data!;
  }

  @action
  void _scrollDown(ScrollController? scrollController) {
    if (scrollController != null) {
      Timer(const Duration(milliseconds: 10), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
  }
}
