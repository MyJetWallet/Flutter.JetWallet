import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/market_details/helper/format_news_date.dart';
import 'package:jetwallet/features/market/market_details/store/market_news_store.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_response_model.dart';

import '../about_block/components/clickable_underlined_text.dart';

class MarketNewsBlock extends StatelessObserverWidget {
  const MarketNewsBlock({
    super.key,
    required this.news,
    required this.assetId,
  });

  final List<MarketNewsModel> news;
  final String assetId;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final newsN = MarketNewsStore.of(context);

    Color newsColor(Sentiment sentiment) {
      switch (sentiment) {
        case Sentiment.neutral:
          return colors.yellowLight;
        case Sentiment.positive:
          return colors.green;
        case Sentiment.negative:
          return colors.red;
      }
    }

    return news.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH27(),
              SPaddingH24(child: Text(intl.news, style: sTextH4Style)),
              const SpaceH22(),
              ListView.builder(
                itemCount: news.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) => SNewsCategory(
                  newsLabel: news[index].source,
                  newsText: news[index].topic,
                  sentiment: newsColor(news[index].sentiment),
                  timestamp: formatNewsDate(news[index].timestamp),
                  onTap: () => launchURL(context, news[index].urlAddress),
                  text1: intl.marketNewsBlock_discussOn,
                  text2: intl.marketNewsBlock_cryptoPanic,
                ),
              ),
              if (news.length >= newsPortionAmount) ...[
                SPaddingH24(
                  child: ClickableUnderlinedText(
                    text: newsN.canLoadMore ? intl.marketNewsBlock_readMore : intl.marketNewsBlock_readLess,
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
          )
        : Container();
  }
}
