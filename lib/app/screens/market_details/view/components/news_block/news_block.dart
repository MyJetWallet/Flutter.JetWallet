import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../market/view/components/header_text.dart';
import '../../../notifier/news_notipod.dart';
import '../../../provider/news_fpod.dart';
import '../about_block/components/clickable_underlined_text.dart';
import 'components/news_item.dart';

class NewsBlock extends HookWidget {
  const NewsBlock({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final newsInit = useProvider(newsInitFpod(assetId));
    final newsN = useProvider(newsNotipod.notifier);
    final news = useProvider(newsNotipod);

    return newsInit.when(
      data: (_) {
        if (news.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderText(
                text: 'News',
                textAlign: TextAlign.start,
              ),
              const SpaceH8(),
              ListView.builder(
                itemCount: news.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return NewsItem(
                    item: news[index],
                  );
                },
              ),
              if (news.length >= newsPortionAmount) ...[
                ClickableUnderlinedText(
                  text: newsN.isReadMore ? 'Read more' : 'Read Less',
                  onTap: () {
                    if (newsN.isReadMore) {
                      newsN.loadMoreNews(assetId);
                    } else {
                      newsN.cutNewToDefaultSize();
                    }
                  },
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
