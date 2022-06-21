import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/market_news/model/market_news_response_model.dart';

import '../../../../../../../shared/helpers/launch_url.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../helper/format_news_date.dart';
import '../../../notifier/market_news_notipod.dart';
import '../../../provider/market_news_fpod.dart';
import '../about_block/components/clickable_underlined_text.dart';

class MarketNewsBlock extends HookWidget {
  const MarketNewsBlock({
    Key? key,
    required this.news,
    required this.assetId,
  }) : super(key: key);

  final List<MarketNewsModel> news;
  final String assetId;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final newsN = useProvider(marketNewsNotipod.notifier);

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

    if (news.isNotEmpty) {
      return Stack(
        children: [
          Positioned(
            top: 52,
            child: Container(
              width: 300,
              height: 30,
              color: Colors.red.withOpacity(0.6),
              child: Text('30dp'),
            ),
          ),
          Positioned(
            top: 82,
            child: Container(
              width: 300,
              height: 20,
              color: Colors.blue.withOpacity(0.6),
              child: Text('20dp'),
            ),
          ),

          Positioned(
            top: 117,
            child: Container(
              width: 300,
              height: 30,
              color: Colors.red.withOpacity(0.6),
              child: Text('30dp'),
            ),
          ),

          Positioned(
            top: 171,
            child: Container(
              width: 300,
              height: 20,
              color: Colors.blue.withOpacity(0.6),
              child: Text('20dp'),
            ),
          ),

          Positioned(
            top: 191,
            child: Container(
              width: 300,
              height: 20,
              color: Colors.red.withOpacity(0.6),
              child: Text('20dp'),
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH27(),
              SPaddingH24(
                child: Text(
                  intl.news,
                  style: sTextH4Style,
                ),
              ),
              const SpaceH22(),
              ListView.builder(
                itemCount: news.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) => SNewsCategory(
                  newsLabel: news[index].source,
                  newsText: news[index].topic,
                  sentiment: _newsColor(
                    news[index].sentiment,
                  ),
                  timestamp: formatNewsDate(
                    news[index].timestamp,
                  ),
                  onTap: () => launchURL(
                    context,
                    news[index].urlAddress,
                  ),
                  text1: intl.marketNewsBlock_discussOn,
                  text2: intl.marketNewsBlock_cryptoPanic,
                ),
              ),
              if (news.length >= newsPortionAmount) ...[
                SPaddingH24(
                  child: ClickableUnderlinedText(
                    text: newsN.canLoadMore
                        ? intl.marketNewsBlock_readMore
                        : intl.marketNewsBlock_readLess,
                    onTap: () {
                      if (newsN.canLoadMore) {
                        newsN.loadMoreNews(assetId);
                      } else {
                        newsN.cutNewToDefaultSize();
                      }
                    },
                  ),
                ),
              ],
              const SpaceH74(),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
