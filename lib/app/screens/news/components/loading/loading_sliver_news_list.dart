import 'package:flutter/material.dart';
import 'news_list_loading_item.dart';

class LoadingSliverNewsList extends StatelessWidget {
  const LoadingSliverNewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        NewsListLoadingItem(
          opacity: 1,
        ),
        NewsListLoadingItem(
          opacity: 0.9,
        ),
        NewsListLoadingItem(
          opacity: 0.8,
        ),
        NewsListLoadingItem(
          opacity: 0.7,
        ),
        NewsListLoadingItem(
          opacity: 0.6,
        ),
        NewsListLoadingItem(
          opacity: 0.4,
          removeDivider: true,
        ),
        NewsListLoadingItem(
          opacity: 0.3,
          removeDivider: true,
        ),
        NewsListLoadingItem(
          opacity: 0.2,
          removeDivider: true,
        ),
        NewsListLoadingItem(
          opacity: 0.1,
          removeDivider: true,
        ),
      ]),
    );
  }
}
