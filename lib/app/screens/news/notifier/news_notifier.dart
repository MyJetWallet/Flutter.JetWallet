import 'dart:async';

import 'package:flutter/material.dart';
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
  }) : super(const NewsState()) {
    init(null);
  }

  final Reader read;

  static final _logger = Logger('NewsNotifier');

  Future<void> init(ScrollController? scrollController) async {
    try {
      final news = await _requestNews(
        NewsRequestModel(
          batchSize: 20,
          language: read(intlPod).localeName,
        ),
      );

      _updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'init', e);

      read(sNotificationNotipod.notifier).showError(
        'Something went wrong',
        id: 1,
      );
      if (scrollController != null) {
        Timer(const Duration(milliseconds: 100), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }

      state = state.copyWith(union: const Error());
    }
  }

  Future<void> news(String? assetId, ScrollController? scrollController) async {
    _logger.log(notifier, 'news');

    try {
      final news = await _requestNews(
        NewsRequestModel(
          assetId: assetId,
          batchSize: 20,
          lastDate: state.newsItems.last.timestamp,
          language: read(intlPod).localeName,
        ),
      );

      _updateNews(news.news);
    } catch (e) {
      _logger.log(stateFlow, 'news', e);

      read(sNotificationNotipod.notifier).showError(
        'Something went wrong',
        id: 2,
      );
      if (scrollController != null) {
        Timer(const Duration(milliseconds: 100), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
      state = state.copyWith(union: const Error());
    }
  }

  void _updateNews(List<NewsModel> items) {
    if (items.isEmpty) {
      state = state.copyWith(
        nothingToLoad: true,
        union: const Loaded(),
      );
    } else {
      state = state.copyWith(
        newsItems: state.newsItems + items,
        union: const Loaded(),
      );
    }
  }

  Future<NewsResponseModel> _requestNews(
    NewsRequestModel model,
  ) {
    state = state.copyWith(union: const Loading());

    return read(newsServicePod).news(model);
  }
}
