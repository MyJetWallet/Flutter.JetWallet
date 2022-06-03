import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/market_news/model/market_news_response_model.dart';

import '../../../../../../shared/helpers/launch_url.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/features/market_details/helper/format_news_date.dart';
import '../../../notifier/news_notipod.dart';
import '../../../notifier/news_state.dart';
import '../../../notifier/news_union.dart';
import '../news_loading_skeleton/news_loading_skeleton.dart';
import 'components/news_web_view.dart';

class NewsList extends StatefulHookWidget {
  const NewsList({
    Key? key,
    required this.scrollController,
    required this.errorBoxPaddingMultiplier,
  }) : super(key: key);

  final ScrollController scrollController;
  final double errorBoxPaddingMultiplier;

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        final news = context.read(newsNotipod);

        if (news.union == const NewsUnion.loaded() && !news.nothingToLoad) {
          final newsN = context.read(newsNotipod.notifier);

          newsN.news(widget.scrollController);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final newsN = useProvider(newsNotipod.notifier);
    final news = useProvider(newsNotipod);
    final screenHeight = MediaQuery.of(context).size.height;

    Color _newsColor(Sentiment sentiment) {
      switch (sentiment) {
        case Sentiment.neutral:
          return colors.yellowLight;
        case Sentiment.positive:
          return colors.green;
        case Sentiment.negative:
          return colors.red;
      }
    }

    return SliverPadding(
      padding: EdgeInsets.only(
        top: news.union != const NewsUnion.error() ? 15 : 0,
        bottom: _addBottomPadding(news) ? 72 : 0,
      ),
      sliver: news.union.when(
        loading: () {
          if (news.newsItems.isEmpty) {
            return const NewsLoadingSkeleton();
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (news.newsItems[index] == news.newsItems.last) {
                    return Column(
                      children: [
                        SNewsCategory(
                          newsLabel: news.newsItems[index].source,
                          newsText: news.newsItems[index].topic,
                          sentiment: _newsColor(
                            news.newsItems[index].sentiment,
                          ),
                          timestamp: formatNewsDate(
                            news.newsItems[index].timestamp,
                          ),
                          onTap: () {
                            NewsWebView.push(
                              context,
                              news.newsItems[index].urlAddress,
                              news.newsItems[index].topic,
                            );
                          },
                          text1: intl.marketNewsBlock_discussOn,
                          text2: intl.newsList_cryptoPanic,
                        ),
                        const SpaceH24(),
                        Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            color: colors.grey5,
                            shape: BoxShape.circle,
                          ),
                          child: const RiveAnimation.asset(
                            loadingAnimationAsset,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SNewsCategory(
                      newsLabel: news.newsItems[index].source,
                      newsText: news.newsItems[index].topic,
                      sentiment: _newsColor(
                        news.newsItems[index].sentiment,
                      ),
                      timestamp: formatNewsDate(
                        news.newsItems[index].timestamp,
                      ),
                      onTap: () => launchURL(
                        context,
                        news.newsItems[index].urlAddress,
                      ),
                      text1: intl.marketNewsBlock_discussOn,
                      text2: intl.newsList_cryptoPanic,
                    );
                  }
                },
                childCount: news.newsItems.length,
              ),
            );
          }
        },
        loaded: () {
          if (news.newsItems.isEmpty) {
            return SliverToBoxAdapter(
              child: SizedBox(
                height: screenHeight - screenHeight * 0.369,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      intl.newsList_noNewsYet,
                      style: sTextH3Style,
                    ),
                    Text(
                      intl.newsList_text1,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SNewsCategory(
                    newsLabel: news.newsItems[index].source,
                    newsText: news.newsItems[index].topic,
                    sentiment: _newsColor(
                      news.newsItems[index].sentiment,
                    ),
                    timestamp: formatNewsDate(
                      news.newsItems[index].timestamp,
                    ),
                    onTap: () {
                      NewsWebView.push(
                        context,
                        news.newsItems[index].urlAddress,
                        news.newsItems[index].topic,
                      );
                    },
                    text1: intl.marketNewsBlock_discussOn,
                    text2: intl.newsList_cryptoPanic,
                  );
                },
                childCount: news.newsItems.length,
              ),
            );
          }
        },
        error: () {
          if (news.newsItems.isEmpty) {
            return SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    height: 137,
                    margin: EdgeInsets.only(
                      top: screenHeight -
                          (screenHeight * widget.errorBoxPaddingMultiplier),
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 2,
                        color: colors.grey4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 22,
                                top: 22,
                                right: 12,
                              ),
                              child: SErrorIcon(
                                color: colors.red,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                child: SizedBox(
                                  height: 77,
                                  child: Baseline(
                                    baseline: 38,
                                    baselineType: TextBaseline.alphabetic,
                                    child: Text(
                                      intl.newsList_wentWrongText,
                                      style: sBodyText1Style,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        STextButton1(
                          active: true,
                          name: intl.news_retry,
                          onTap: () {
                            newsN.init(widget.scrollController);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (news.newsItems[index] == news.newsItems.last) {
                    return Column(
                      children: [
                        SNewsCategory(
                          newsLabel: news.newsItems[index].source,
                          newsText: news.newsItems[index].topic,
                          sentiment: _newsColor(
                            news.newsItems[index].sentiment,
                          ),
                          timestamp: formatNewsDate(
                            news.newsItems[index].timestamp,
                          ),
                          onTap: () => launchURL(
                            context,
                            news.newsItems[index].urlAddress,
                          ),
                          text1: intl.marketNewsBlock_discussOn,
                          text2: intl.newsList_cryptoPanic,
                        ),
                        Container(
                          width: double.infinity,
                          height: 137,
                          margin: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 2,
                              color: colors.grey4,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 22,
                                      top: 22,
                                      right: 12,
                                    ),
                                    child: SErrorIcon(
                                      color: colors.red,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 20,
                                      ),
                                      child: SizedBox(
                                        height: 77,
                                        child: Baseline(
                                          baseline: 38,
                                          baselineType: TextBaseline.alphabetic,
                                          child: Text(
                                            intl.newsList_wentWrongText,
                                            style: sBodyText1Style,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              STextButton1(
                                active: true,
                                name: intl.news_retry,
                                onTap: () {
                                  newsN.news(widget.scrollController);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SNewsCategory(
                      newsLabel: news.newsItems[index].source,
                      newsText: news.newsItems[index].topic,
                      sentiment: _newsColor(
                        news.newsItems[index].sentiment,
                      ),
                      timestamp: formatNewsDate(
                        news.newsItems[index].timestamp,
                      ),
                      onTap: () => launchURL(
                        context,
                        news.newsItems[index].urlAddress,
                      ),
                      text1: intl.marketNewsBlock_discussOn,
                      text2: intl.newsList_cryptoPanic,
                    );
                  }
                },
                childCount: news.newsItems.length,
              ),
            );
          }
        },
      ),
    );
  }

  bool _addBottomPadding(NewsState news) {
    return (news.union != const NewsUnion.error()) && !news.nothingToLoad;
  }
}
