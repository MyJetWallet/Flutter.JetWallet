import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/news/ui/widgets/news_list/news_list.dart';
import 'package:simple_kit/simple_kit.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
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
