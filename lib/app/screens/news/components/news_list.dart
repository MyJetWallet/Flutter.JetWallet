import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'loading/loading_sliver_news_list.dart';

class NewsList extends StatefulHookWidget {
  const NewsList({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.maxScrollExtent ==
          widget.scrollController.offset) {

      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingSliverNewsList();
  }
}
