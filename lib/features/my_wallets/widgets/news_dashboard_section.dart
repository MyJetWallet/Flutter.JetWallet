import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/market/market_details/store/market_news_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/shared/simple_skeleton_loader.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_response_model.dart';

class NewsDashboardSection extends StatelessWidget {
  const NewsDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final newsStore = MarketNewsStore.of(context);
        final news = newsStore.news;

        return news.isEmpty
            ? const Offstage()
            : CustomScrollView(
                shrinkWrap: true,
                primary: false,
                slivers: [
                  SliverToBoxAdapter(
                    child: SBasicHeader(
                      title: intl.news,
                      subtitle: intl.news_section_partner,
                      showLinkButton: false,
                      subtitleIcon: SvgPicture.asset(
                        cryptopanicLogo,
                      ),
                    ),
                  ),
                  if (newsStore.isLoading)
                    SliverList.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const LoadingNewsItem();
                      },
                    )
                  else
                    SliverList.builder(
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return NewsItem(news: news[index]);
                      },
                    ),
                  if (newsStore.isLoadingPagination)
                    SliverList.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const LoadingNewsItem();
                      },
                    ),
                ],
              );
      },
    );
  }
}

class NewsItem extends HookWidget {
  const NewsItem({super.key, required this.news});

  final MarketNewsModel news;

  @override
  Widget build(BuildContext context) {
    final isHighlated = useState(false);

    final colors = SColorsLight();

    var assets = <CurrencyModel>[];

    for (final assetId in news.associatedAssets) {
      final asset = getIt.get<FormatService>().findCurrency(
            assetSymbol: assetId,
            findInHideTerminalList: true,
          );
      if (asset.symbol != 'unknown') {
        assets.add(asset);
      }
    }

    assets = assets.sublist(0, min(assets.length, 3));

    return SafeGesture(
      onTap: () async {
        getIt.get<EventBus>().fire(EndReordering());
        await launchURL(context, news.urlAddress);
      },
      highlightColor: colors.gray2,
      onHighlightChanged: (p0) {
        isHighlated.value = p0;
      },
      child: ColoredBox(
        color: isHighlated.value ? colors.gray2 : Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _AssociatedAssetsRow(assets: assets),
                  const SizedBox(width: 4),
                  Text(
                    '•',
                    style: STStyles.body2Medium.copyWith(
                      color: colors.gray6,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMMM').format(news.timestamp),
                    style: STStyles.body2Medium.copyWith(
                      color: colors.gray10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.source,
                          style: STStyles.subtitle1,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          news.topic,
                          style: STStyles.body1Medium.copyWith(
                            color: colors.gray10,
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  if (news.imageUrl != null && news.imageUrl != '')
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Container(
                          width: 56,
                          height: 56,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: news.imageUrl ?? '',
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            placeholder: (context, url) => SSkeletonLoader(
                              width: 56,
                              height: 56,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorWidget: (context, url, error) => const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssociatedAssetsRow extends StatelessWidget {
  const _AssociatedAssetsRow({required this.assets});

  final List<CurrencyModel> assets;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return assets.isNotEmpty
        ? Row(
            children: [
              SizedBox(
                width: assets.length > 1 ? (16 * assets.length + 4).toDouble() : 20,
                height: 20,
                child: Stack(
                  children: [
                    for (var i = 0; i < assets.length; i++)
                      Positioned(
                        right: i == 0 ? 0 : i * 16,
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.5,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: SNetworkSvg(
                            width: 20,
                            height: 20,
                            url: assets.reversed.toList()[i].iconUrl,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              for (var i = 0; i < assets.length; i++)
                Builder(
                  builder: (context) {
                    final text = assets[i].symbol + (i == assets.length - 1 ? '' : ', ');
                    return Text(
                      text,
                      style: STStyles.body2Semibold.copyWith(
                        color: colors.black,
                      ),
                    );
                  },
                ),
            ],
          )
        : Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: ShapeDecoration(
                  color: colors.blue,
                  shape: const OvalBorder(),
                ),
                padding: const EdgeInsets.all(4),
                child: Assets.svg.medium.crypto.simpleSvg(
                  width: 12,
                  height: 12,
                  color: colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                intl.news_section_crypto_news,
                style: STStyles.body2Semibold.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          );
  }
}

class LoadingNewsItem extends StatelessWidget {
  const LoadingNewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SSkeletonLoader(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(width: 8),
              SSkeletonLoader(
                width: 32,
                height: 8,
                borderRadius: BorderRadius.circular(2),
              ),
              const SizedBox(width: 8),
              SSkeletonLoader(
                width: 48,
                height: 8,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SSkeletonLoader(
                    width: MediaQuery.of(context).size.width - 124,
                    height: 12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 10),
                  SSkeletonLoader(
                    width: MediaQuery.of(context).size.width - 124,
                    height: 12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 10),
                  SSkeletonLoader(
                    width: 154,
                    height: 12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              SSkeletonLoader(
                width: 56,
                height: 56,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
