import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            Text(
              '${item.source} ',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const Text(
              '•',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              ' ${timeago.format(DateTime.parse(item.timestamp))}',
              style: const TextStyle(
                color: Colors.grey,
              ),
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
