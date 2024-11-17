import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:charts/simple_chart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/invest/stores/chart/invest_chart_store.dart';
import 'package:jetwallet/features/invest/ui/widgets/small_chart.dart';
import 'package:jetwallet/features/market/helper/percent_price_cahange.dart';
import 'package:jetwallet/features/market/helper/sector_extensions.dart';
import 'package:jetwallet/features/market/store/market_sector_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/models/segment_control_data.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/segment_control.dart';
import 'package:simple_kit_updated/widgets/table/divider/simple_divider.dart' as divider;
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

@RoutePage(name: 'MarketSectorDetailsRouter')
class MarketSectorDetailsScreen extends StatefulWidget {
  const MarketSectorDetailsScreen({super.key, required this.sector});

  final MarketSectorModel sector;

  @override
  State<MarketSectorDetailsScreen> createState() => _MarketSectorDetailsScreenState();
}

class _MarketSectorDetailsScreenState extends State<MarketSectorDetailsScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<MarketSectorStore>(
      create: (context) => MarketSectorStore(widget.sector, this),
      child: const _MarketSectorDetailsBody(),
      dispose: (context, store) {
        store.dispose();
      },
    );
  }
}

class _MarketSectorDetailsBody extends StatefulWidget {
  const _MarketSectorDetailsBody();

  @override
  State<_MarketSectorDetailsBody> createState() => _MarketSectorDetailsBodyState();
}

class _MarketSectorDetailsBodyState extends State<_MarketSectorDetailsBody> with TickerProviderStateMixin {
  List<String> openedAssets = [];

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = MarketSectorStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    final chartStore = getIt.get<InvestChartStore>();

    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      child: Observer(
        builder: (context) {
          final assets = store.filtredMarketItems;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                sliver: SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: store.sector.bigImageUrl,
                      height: 160,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholder: (_, __) {
                        return SSkeletonLoader(
                          width: MediaQuery.of(context).size.width - 48,
                          height: 160,
                          borderRadius: BorderRadius.circular(16),
                        );
                      },
                      errorWidget: (_, __, ___) {
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: store.sector.title,
                              style: STStyles.header5.copyWith(
                                color: colors.black,
                              ),
                            ),
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(width: 8),
                            ),
                            TextSpan(
                              text:
                                  '${store.sector.countOfTokens} ${store.sector.countOfTokens == 1 ? intl.market_token : intl.market_tokens}',
                              style: STStyles.body2Semibold.copyWith(
                                color: colors.gray10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          store.setShortDescription();
                        },
                        child: ReadMoreText(
                          store.sector.description,
                          isCollapsed: ValueNotifier<bool>(store.isShortDescription),
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          colorClickableText: Colors.blue,
                          trimCollapsedText: ' ${intl.prepaid_card_more}',
                          trimExpandedText: ' ${intl.prepaid_card_less}',
                          style: STStyles.body1Medium.copyWith(
                            color: colors.gray10,
                          ),
                          moreStyle: STStyles.body1Medium.copyWith(
                            color: colors.blue,
                          ),
                          lessStyle: STStyles.body1Medium.copyWith(
                            color: colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: SInput(
                    controller: store.searchContriller,
                    hint: intl.showKycCountryPicker_search,
                    onChanged: (value) {},
                    height: 44,
                    withoutVerticalPadding: true,
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: divider.SDivider(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      SDropdownmenuButton(
                        value: store.selectedFilter,
                        itmes: store.marketItemsFilter,
                        onChanged: (filter) {
                          if (filter != null) {
                            store.selectFilter(filter);
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      SegmentControl(
                        tabController: store.tabController,
                        shrinkWrap: true,
                        isInvest: true,
                        items: [
                          SegmentControlData(
                            type: SegmentControlType.icon,
                            icon: Assets.svg.medium.sortingDown,
                          ),
                          SegmentControlData(
                            type: SegmentControlType.icon,
                            icon: Assets.svg.medium.sortingUp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final currency = getIt.get<FormatService>().findCurrency(
                        findInHideTerminalList: true,
                        assetSymbol: assets[index].symbol,
                      );

                  return FutureBuilder<List<CandleModel>>(
                    future: chartStore.getAssetCandles(store.filtredMarketItems[index].associateAssetPair),
                    builder: (context, snapshot) {
                      return SimpleTableAsset(
                        assetIcon: NetworkIconWidget(
                          currency.iconUrl,
                        ),
                        label: currency.description,
                        rightValue: (baseCurrency.symbol == currency.symbol ? Decimal.one : currency.currentPrice)
                            .toFormatPrice(
                          prefix: baseCurrency.prefix,
                          accuracy: store.filtredMarketItems[index].priceAccuracy,
                        ),
                        supplement: currency.symbol,
                        isRightValueMarket: true,
                        rightMarketValue: formatedPercentPriceCahange(snapshot.data ?? []),
                        rightValueMarketPositive: percentPriceCahange(snapshot.data ?? []) >= 0,
                        onTableAssetTap: () {
                          if (!openedAssets.contains(store.filtredMarketItems[index].symbol)) {
                            setState(() {
                              openedAssets.add(store.filtredMarketItems[index].symbol);
                            });
                            if (openedAssets.length == 2) {
                              AnchorsHelper().addForgotSectorsAnchor(store.sector.id);
                            }
                          }

                          sRouter.push(
                            MarketDetailsRouter(
                              marketItem: store.filtredMarketItems[index],
                            ),
                          );
                        },
                        chartWidget: SmallChart(
                          candles: snapshot.data?.reversed.toList() ?? <CandleModel>[],
                          width: 32,
                          height: 12,
                          lineWith: 1.8,
                          maxCandles: 20,
                        ),
                      );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          );
        },
      ),
    );
  }
}
