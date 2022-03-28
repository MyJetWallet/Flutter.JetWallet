import 'package:flutter/material.dart';
import 'news_list_loading_item.dart';

class LoadingSliverNewsList extends StatelessWidget {
  const LoadingSliverNewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        for (var i = 10; i >= 1; i--) ...[
          NewsListLoadingItem(
            opacity: i / 10,
            removeDivider: true,
          ),
        ]
      ]),
    );
  }
}
