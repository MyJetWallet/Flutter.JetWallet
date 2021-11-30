import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../service/services/education_news/model/education_news_response_model.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/helpers/launch_url.dart';
import '../../shared/features/education_news/notifier/education_news_notipod.dart';
import '../../shared/features/education_news/provider/education_news_fpod.dart';
import '../../shared/features/market_details/helper/format_news_date.dart';

class Education extends HookWidget {
  const Education({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsInit = useProvider(educationNewsInitFpod);
    final educationNewsN = useProvider(educationNewsNotipod.notifier);
    final educationNews = useProvider(educationNewsNotipod);
    final _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        educationNewsN.loadMoreNews();
      }
    });

    return newsInit.when(
      data: (_) {
        if (educationNews.news.isNotEmpty) {
          return SPageFrame(
            header: SMarketHeaderClosed(
              title: 'News',
              isDivider: true,
              onSearchButtonTap: () {},
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) => SNewsCategory(
                newsLabel: educationNews.news[index].source,
                newsText: educationNews.news[index].topic,
                sentiment: _newsColor(
                  educationNews.news[index].sentiment,
                ),
                timestamp: formatNewsDate(
                  educationNews.news[index].timestamp,
                ),
                onTap: () => launchURL(
                  context,
                  educationNews.news[index].urlAddress,
                ),
              ),
              itemCount: educationNews.news.length,
            ),
          );
        } else {
          return Container();
        }
      },
      loading: () => const Loader(),
      error: (_, __) => Container(),
    );
  }

  Color _newsColor(Sentiment sentiment) {
    switch (sentiment) {
      case Sentiment.neutral:
        return Colors.yellow;
      case Sentiment.positive:
        return Colors.green;
      case Sentiment.negative:
        return Colors.red;
    }
  }
}
