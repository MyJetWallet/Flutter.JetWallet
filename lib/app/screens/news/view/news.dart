import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/providers/service_providers.dart';
import 'components/news_list/news_list.dart';

class News extends HookWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final scrollController = useScrollController();

    return SPageFrame(
      header: SMarketHeaderClosed(
        title: intl.news,
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
