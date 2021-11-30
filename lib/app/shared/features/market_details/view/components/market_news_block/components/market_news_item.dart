import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../service/services/market_news/model/market_news_response_model.dart';


import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/launch_url.dart';
import '../../../../helper/format_news_date.dart';
import 'market_news_item_text.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final MarketNewsModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchURL(context, item.urlAddress),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _newsColor(item.sentiment),
                ),
              ),
              const SpaceW4(),
              Expanded(
                child: MarketNewsItemText(
                  text: '${item.source} ',
                ),
              ),
              const MarketNewsItemText(
                text: '•',
              ),
              MarketNewsItemText(
                text: formatNewsDate(item.timestamp),
              ),
            ],
          ),
          const SpaceH4(),
          Text(
            item.topic,
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          const SpaceH4(),
          const Divider(),
        ],
      ),
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
