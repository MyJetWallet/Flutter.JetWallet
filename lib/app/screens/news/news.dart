import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../service/services/news/model/news_response_model.dart';
import '../../../shared/components/loaders/loader.dart';
import '../../../shared/helpers/launch_url.dart';
import '../../shared/features/market_details/helper/format_news_date.dart';
import '../../shared/features/news/notifier/education_news_notipod.dart';
import '../../shared/features/news/provider/education_news_fpod.dart';

class News extends StatefulHookWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final notifier = context.read(newsNotipod.notifier);
        notifier.loadMoreNews();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsInit = useProvider(newsInitFpod);
    final news = useProvider(newsNotipod);

    return newsInit.when(
      data: (_) {
        if (news.news.isNotEmpty) {
          return SPageFrame(
            header: SMarketHeaderClosed(
              title: 'News',
              isDivider: true,
              onSearchButtonTap: () {},
            ),
            child: ListView.builder(
              key: const PageStorageKey<String>('_scrollController'),
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) => SNewsCategory(
                newsLabel: news.news[index].source,
                newsText: news.news[index].topic,
                sentiment: _newsColor(
                  news.news[index].sentiment,
                ),
                timestamp: formatNewsDate(
                  news.news[index].timestamp,
                ),
                onTap: () => launchURL(
                  context,
                  news.news[index].urlAddress,
                ),
                height: 110.h,
                padding: EdgeInsets.symmetric(vertical: 20.h),
              ),
              itemCount: news.news.length,
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
        return SColorsLight().yellowLight;
      case Sentiment.positive:
        return SColorsLight().green;
      case Sentiment.negative:
        return SColorsLight().red;
    }
  }
}
