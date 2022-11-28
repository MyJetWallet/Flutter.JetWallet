import 'package:flutter/material.dart';
import 'components/news_loading_item.dart';

class NewsLoadingSkeleton extends StatelessWidget {
  const NewsLoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          for (var i = 10; i >= 1; i--) ...[
            NewsLoadingItem(
              opacity: i / 10,
              removeDivider: true,
            ),
          ],
        ],
      ),
    );
  }
}
