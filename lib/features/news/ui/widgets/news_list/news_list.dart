import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/market_details/helper/format_news_date.dart';
import 'package:jetwallet/features/news/models/news_union.dart';
import 'package:jetwallet/features/news/store/news_store.dart';
import 'package:jetwallet/features/news/ui/widgets/news_loading_skeleton/news_loading_skeleton.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_response_model.dart';

class NewsList extends StatelessWidget {
  const NewsList({
    Key? key,
    required this.scrollController,
    required this.errorBoxPaddingMultiplier,
  }) : super(key: key);

  final ScrollController scrollController;
  final double errorBoxPaddingMultiplier;

  @override
  Widget build(BuildContext context) {
    return Provider<NewsStore>(
      create: (context) => NewsStore(),
      builder: (context, child) => NewsListBody(
        errorBoxPaddingMultiplier: errorBoxPaddingMultiplier,
        scrollController: scrollController,
      ),
    );
  }
}

class NewsListBody extends StatefulObserverWidget {
  const NewsListBody({
    Key? key,
    required this.scrollController,
    required this.errorBoxPaddingMultiplier,
  }) : super(key: key);

  final ScrollController scrollController;
  final double errorBoxPaddingMultiplier;

  @override
  State<NewsListBody> createState() => _NewsListBodyState();
}

class _NewsListBodyState extends State<NewsListBody> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {
        final newsStore = NewsStore.of(context);

        if (newsStore.union == const NewsUnion.loaded() &&
            !newsStore.nothingToLoad) {
          newsStore.news(widget.scrollController);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final newsStore = NewsStore.of(context);
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
        top: newsStore.union != const NewsUnion.error() ? 20 : 0,
        bottom: (newsStore.union != const NewsUnion.error()) &&
                !newsStore.nothingToLoad
            ? 72
            : 0,
      ),
      sliver: newsStore.union.when(
        loading: () {
          return newsStore.newsItems.isEmpty
              ? const NewsLoadingSkeleton()
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return newsStore.newsItems[index] ==
                              newsStore.newsItems.last
                          ? Column(
                              children: [
                                SNewsCategory(
                                  newsLabel: newsStore.newsItems[index].source,
                                  newsText: newsStore.newsItems[index].topic,
                                  sentiment: _newsColor(
                                    newsStore.newsItems[index].sentiment,
                                  ),
                                  timestamp: formatNewsDate(
                                    newsStore.newsItems[index].timestamp,
                                  ),
                                  onTap: () {
                                    sRouter.push(
                                      NewsWebViewRouter(
                                        link: newsStore
                                            .newsItems[index].urlAddress,
                                        topic: newsStore.newsItems[index].topic,
                                      ),
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
                            )
                          : SNewsCategory(
                              newsLabel: newsStore.newsItems[index].source,
                              newsText: newsStore.newsItems[index].topic,
                              sentiment: _newsColor(
                                newsStore.newsItems[index].sentiment,
                              ),
                              timestamp: formatNewsDate(
                                newsStore.newsItems[index].timestamp,
                              ),
                              onTap: () => launchURL(
                                context,
                                newsStore.newsItems[index].urlAddress,
                              ),
                              text1: intl.marketNewsBlock_discussOn,
                              text2: intl.newsList_cryptoPanic,
                            );
                    },
                    childCount: newsStore.newsItems.length,
                  ),
                );
        },
        loaded: () {
          return newsStore.newsItems.isEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: screenHeight - screenHeight * 0.369,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(intl.newsList_noNewsYet, style: sTextH3Style),
                        Text(
                          intl.newsList_text1,
                          style: sBodyText1Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return SNewsCategory(
                        newsLabel: newsStore.newsItems[index].source,
                        newsText: newsStore.newsItems[index].topic,
                        sentiment:
                            _newsColor(newsStore.newsItems[index].sentiment),
                        timestamp: formatNewsDate(
                          newsStore.newsItems[index].timestamp,
                        ),
                        onTap: () {
                          sRouter.push(
                            NewsWebViewRouter(
                              link: newsStore.newsItems[index].urlAddress,
                              topic: newsStore.newsItems[index].topic,
                            ),
                          );
                        },
                        text1: intl.marketNewsBlock_discussOn,
                        text2: intl.newsList_cryptoPanic,
                      );
                    },
                    childCount: newsStore.newsItems.length,
                  ),
                );
        },
        error: () {
          return newsStore.newsItems.isEmpty
              ? SliverList(
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
                                    padding: const EdgeInsets.only(right: 20),
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
                                newsStore.init(widget.scrollController);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return newsStore.newsItems[index] ==
                              newsStore.newsItems.last
                          ? Column(
                              children: [
                                SNewsCategory(
                                  newsLabel: newsStore.newsItems[index].source,
                                  newsText: newsStore.newsItems[index].topic,
                                  sentiment: _newsColor(
                                    newsStore.newsItems[index].sentiment,
                                  ),
                                  timestamp: formatNewsDate(
                                    newsStore.newsItems[index].timestamp,
                                  ),
                                  onTap: () => launchURL(
                                    context,
                                    newsStore.newsItems[index].urlAddress,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  baselineType:
                                                      TextBaseline.alphabetic,
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
                                          newsStore
                                              .news(widget.scrollController);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SNewsCategory(
                              newsLabel: newsStore.newsItems[index].source,
                              newsText: newsStore.newsItems[index].topic,
                              sentiment: _newsColor(
                                newsStore.newsItems[index].sentiment,
                              ),
                              timestamp: formatNewsDate(
                                newsStore.newsItems[index].timestamp,
                              ),
                              onTap: () => launchURL(
                                context,
                                newsStore.newsItems[index].urlAddress,
                              ),
                              text1: intl.marketNewsBlock_discussOn,
                              text2: intl.newsList_cryptoPanic,
                            );
                    },
                    childCount: newsStore.newsItems.length,
                  ),
                );
        },
      ),
    );
  }
}
