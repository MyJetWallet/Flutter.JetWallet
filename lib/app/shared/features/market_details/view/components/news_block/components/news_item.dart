import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetwallet/app/shared/features/market_details/helper/format_news_date.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../../../service/services/news/model/news_response_model.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/launch_url.dart';
import 'news_item_text.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchURL(context, item.urlAddress),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: NewsItemText(
                  text: '${item.source} ',
                ),
              ),
              const NewsItemText(
                text: '•',
              ),
              NewsItemText(
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
}
