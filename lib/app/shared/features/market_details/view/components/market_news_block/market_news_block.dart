import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../service/services/market_news/model/market_news_response_model.dart';
import '../../../../../../../shared/helpers/launch_url.dart';
import '../../../helper/format_news_date.dart';
import '../../../notifier/market_news_notipod.dart';
import '../../../provider/market_news_fpod.dart';
import '../about_block/components/clickable_underlined_text.dart';

class MarketNewsBlock extends HookWidget {
  const MarketNewsBlock({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final newsInit = useProvider(marketNewsInitFpod(assetId));
    final newsN = useProvider(marketNewsNotipod.notifier);
    final news = useProvider(marketNewsNotipod);
    final colors = useProvider(sColorPod);

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

    return newsInit.when(
      data: (_) {
        if (news.news.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SPaddingH24(
                child: Text(
                  'News',
                  style: sTextH4Style,
                ),
              ),
              const SpaceH33(),
              ListView.builder(
                itemCount: news.news.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
              ),
              if (news.news.length >= newsPortionAmount) ...[
                SPaddingH24(
                  child: ClickableUnderlinedText(
                    text: newsN.canLoadMore ? 'Read more' : 'Read Less',
                    onTap: () {
                      if (newsN.canLoadMore) {
                        newsN.loadMoreNews(assetId);
                      } else {
                        newsN.cutNewToDefaultSize();
                      }
                    },
                  ),
                ),
              ]
            ],
          );
        } else {
          return Container();
        }
      },
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}
