import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../../shared/components/bottom_tabs/bottom_tabs.dart';
import '../../../shared/components/bottom_tabs/components/bottom_tab.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../../../shared/features/market_details/view/market_details.dart';
import '../../../shared/helpers/format_currency_amount.dart';
import '../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../notifier/watchlist/watchlist_notipod.dart';
import '../provider/market_gainers_pod.dart';
import '../provider/market_indices_pod.dart';
import '../provider/market_items_pod.dart';
import '../provider/market_losers_pod.dart';
import 'components/fade_on_scroll.dart';
import 'components/market_banners/market_banners.dart';
import 'components/market_tab_content/components/market_reordable_list.dart';

class Market extends HookWidget {
  const Market({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useProvider(keyValueNotipod);
    useProvider(watchlistIdsNotipod);
    final indices = useProvider(marketIndicesPod);
    final gainers = useProvider(marketGainersPod);
    final losers = useProvider(marketLosersPod);
    final marketTabsLength = _marketTabsLength(
      gainers.isEmpty,
      losers.isEmpty,
      indices.isEmpty,
    );

    return Scaffold(
      body: DefaultTabController(
        length: marketTabsLength,
        child: Stack(
          children: [
            TabBarView(
              children: [
                const AllNestedScrollView(),
                const WatchlistNestedScrollView(),
                if (indices.isNotEmpty) const IndicesNestedScrollView(),
                if (gainers.isNotEmpty) const GainersNestedScrollView(),
                if (losers.isNotEmpty) const LosersNestedScrollView(),
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomTabs(
                tabs: [
                  const BottomTab(text: 'All'),
                  const BottomTab(text: 'Watchlist'),
                  if (indices.isNotEmpty) const BottomTab(text: 'Indices'),
                  if (gainers.isNotEmpty) const BottomTab(text: 'Gainers'),
                  if (losers.isNotEmpty) const BottomTab(text: 'Losers'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _marketTabsLength(
    bool gainersEmpty,
    bool losersEmpty,
    bool indicesEmpty,
  ) {
    var marketTabsLength = 5;

    if (gainersEmpty) {
      marketTabsLength--;
    }
    if (losersEmpty) {
      marketTabsLength--;
    }
    if (indicesEmpty) {
      marketTabsLength--;
    }

    return marketTabsLength;
  }
}

class AllNestedScrollView extends StatefulHookWidget {
  const AllNestedScrollView({Key? key}) : super(key: key);

  @override
  State<AllNestedScrollView> createState() => _AllNestedScrollViewState();
}

class _AllNestedScrollViewState extends State<AllNestedScrollView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final items = useProvider(marketItemsPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: _scrollController,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: const SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Market is up',
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      body: ListView(
        key: const PageStorageKey('all'),
        controller: _controller,
        padding: EdgeInsets.zero,
        children: [
          const MarketBanners(),
          for (final item in items) ...[
            SMarketItem(
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.name,
              price: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: item.lastPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: item.id,
              last: item == items.last,
              percent: item.dayPercentChange,
              onTap: () {
                navigatorPush(
                  context,
                  MarketDetails(
                    marketItem: item,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class WatchlistNestedScrollView extends StatefulHookWidget {
  const WatchlistNestedScrollView({Key? key}) : super(key: key);

  @override
  State<WatchlistNestedScrollView> createState() => _WatchlistNestedScrollViewState();
}

class _WatchlistNestedScrollViewState extends State<WatchlistNestedScrollView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: _scrollController,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: const SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Market is up',
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      body: ListView(
        key: const PageStorageKey('watchlist'),
        controller: _controller,
        padding: EdgeInsets.zero,
        children: const [
          MarketReorderableList(),
        ],
      ),
    );
  }
}

class IndicesNestedScrollView extends StatefulHookWidget {
  const IndicesNestedScrollView({Key? key}) : super(key: key);

  @override
  State<IndicesNestedScrollView> createState() =>
      _IndicesNestedScrollViewState();
}

class _IndicesNestedScrollViewState extends State<IndicesNestedScrollView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final indices = useProvider(marketIndicesPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: _scrollController,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: const SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Market is up',
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      body: ListView(
        key: const PageStorageKey('indices'),
        controller: _controller,
        padding: EdgeInsets.zero,
        children: [
          for (final item in indices) ...[
            SMarketItem(
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.name,
              price: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: item.lastPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: item.id,
              last: item == indices.last,
              percent: item.dayPercentChange,
              onTap: () {
                navigatorPush(
                  context,
                  MarketDetails(
                    marketItem: item,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class GainersNestedScrollView extends StatefulHookWidget {
  const GainersNestedScrollView({Key? key}) : super(key: key);

  @override
  State<GainersNestedScrollView> createState() =>
      _GainersNestedScrollViewState();
}

class _GainersNestedScrollViewState extends State<GainersNestedScrollView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final gainers = useProvider(marketGainersPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return NestedScrollView(
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: _scrollController,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: const SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Market is up',
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      controller: _scrollController,
      body: ListView(
        key: const PageStorageKey('gainers'),
        controller: _controller,
        padding: EdgeInsets.zero,
        children: [
          // const MarketBanners(),
          for (final item in gainers) ...[
            SMarketItem(
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.name,
              price: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: item.lastPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: item.id,
              last: item == gainers.last,
              percent: item.dayPercentChange,
              onTap: () {
                navigatorPush(
                  context,
                  MarketDetails(
                    marketItem: item,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class LosersNestedScrollView extends StatefulHookWidget {
  const LosersNestedScrollView({Key? key}) : super(key: key);

  @override
  State<LosersNestedScrollView> createState() => _LosersNestedScrollViewState();
}

class _LosersNestedScrollViewState extends State<LosersNestedScrollView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final losers = useProvider(marketLosersPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return NestedScrollView(
      headerSliverBuilder: (context, _) {
        return [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            expandedHeight: 160,
            collapsedHeight: 120,
            primary: false,
            flexibleSpace: FadeOnScroll(
              scrollController: _scrollController,
              fullOpacityOffset: 50,
              fadeInWidget: const SDivider(
                width: double.infinity,
              ),
              fadeOutWidget: const SPaddingH24(
                child: SMarketHeader(
                  title: 'Market',
                  percent: 1.73,
                  isPositive: true,
                  subtitle: 'Market is up',
                ),
              ),
              permanentWidget: const SMarketHeaderClosed(
                title: 'Market',
              ),
            ),
          ),
        ];
      },
      controller: _scrollController,
      body: ListView(
        key: const PageStorageKey('losers'),
        controller: _controller,
        padding: EdgeInsets.zero,
        children: [
          // const MarketBanners(),
          for (final item in losers) ...[
            SMarketItem(
              icon: SNetworkSvg24(
                url: item.iconUrl,
              ),
              name: item.name,
              price: formatCurrencyAmount(
                prefix: baseCurrency.prefix,
                value: item.lastPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: item.id,
              last: item == losers.last,
              percent: item.dayPercentChange,
              onTap: () {
                navigatorPush(
                  context,
                  MarketDetails(
                    marketItem: item,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

