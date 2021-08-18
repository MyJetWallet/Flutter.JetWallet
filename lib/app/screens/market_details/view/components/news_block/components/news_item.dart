import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetwallet/app/screens/market_details/view/components/news_block/components/news_item_text.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../../service/services/wallet/model/news/news_response_model.dart';
import '../../../../../../../shared/components/spacers.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NewsModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            NewsItemText(
              text: '${item.source} ',
            ),
            const NewsItemText(
              text: '•',
            ),
            NewsItemText(
              text: ' ${timeago.format(DateTime.parse(item.timestamp))}',
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
        const SpaceH8(),
      ],
    );
  }
}
