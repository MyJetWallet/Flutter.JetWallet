import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/helper/sector_extensions.dart';
import 'package:jetwallet/features/market/store/market_sector_store.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:simple_kit/simple_kit.dart';
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
  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final store = MarketSectorStore.of(context);
    final baseCurrency = sSignalRModules.baseCurrency;

    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      child: Observer(
        builder: (context) {
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
                    child: Image.network(
                      store.sector.imageUrl,
                      height: 160,
                      fit: BoxFit.cover,
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
                              text: '${store.sector.countOfTokens} tokens',
                              style: STStyles.body2Semibold.copyWith(
                                color: colors.gray10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ReadMoreText(
                        store.sector.description,
                        isCollapsed: ValueNotifier<bool>(true),
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
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: SStandardField(
                    controller: store.searchContriller,
                    hintText: intl.showKycCountryPicker_search,
                    onChanged: (value) {},
                    height: 44,
                    maxLines: 1,
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
                itemCount: store.filtredMarketItems.length,
                itemBuilder: (context, index) {
                  final currency = getIt.get<FormatService>().findCurrency(
                        findInHideTerminalList: true,
                        assetSymbol: store.filtredMarketItems[index].symbol,
                      );
                  return SimpleTableAsset(
                    assetIcon: NetworkIconWidget(
                      currency.iconUrl,
                    ),
                    label: currency.description,
                    rightValue:
                        (baseCurrency.symbol == currency.symbol ? Decimal.one : currency.currentPrice).toFormatPrice(
                      prefix: baseCurrency.prefix,
                      accuracy: store.filtredMarketItems[index].priceAccuracy,
                    ),
                    supplement: currency.symbol,
                    isRightValueMarket: true,
                    rightMarketValue: formatPercent(currency.dayPercentChange),
                    rightValueMarketPositive: currency.dayPercentChange > 0,
                    onTableAssetTap: () {
                      sRouter.push(
                        MarketDetailsRouter(
                          marketItem: store.filtredMarketItems[index],
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
