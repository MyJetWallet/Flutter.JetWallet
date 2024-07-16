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
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/market_news/market_news_response_model.dart';

class NewsDashboardSection extends StatelessWidget {
  const NewsDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final colors = SColorsLight();

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
                  SliverList.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return NewsItem(news: news[index]);
                    },
                  ),
                  if (newsStore.isLoadingPagination)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            color: colors.gray2,
                            shape: BoxShape.circle,
                          ),
                          child: const RiveAnimation.asset(
                            loadingAnimationAsset,
                          ),
                        ),
                      ),
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

    final asset = getIt.get<FormatService>().findCurrency(
          assetSymbol: news.associatedAssets.first,
        );
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
                  SNetworkSvg(
                    width: 20,
                    height: 20,
                    url: asset.iconUrl,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    asset.symbol,
                    style: STStyles.body2Semibold.copyWith(
                      color: colors.black,
                    ),
                  ),
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
              Text(
                news.source,
                style: STStyles.subtitle1,
                maxLines: 3,
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      news.topic,
                      style: STStyles.body1Medium.copyWith(
                        color: colors.gray10,
                      ),
                      maxLines: 5,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        width: 56,
                        height: 56,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(news.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
