import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../view/components/news_list.dart';

class News extends HookWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return SPageFrame(
      header: const SMarketHeaderClosed(
        title: 'News',
        isDivider: true,
      ),
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          NewsList(
            scrollController: scrollController,
            errorBoxPaddingMultiplier: 0.467,
          ),
        ],
      ),
    );
  }
}
