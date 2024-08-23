import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:readmore/readmore.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/market_sectors_message_model.dart';

@RoutePage(name: 'MarketSectorDetailsRouter')
class MarketSectorDetailsScreen extends StatelessWidget {
  const MarketSectorDetailsScreen({super.key, required this.sector});

  final MarketSectorModel sector;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SPageFrame(
      loaderText: '',
      header: const GlobalBasicAppBar(
        hasRightIcon: false,
      ),
      child: CustomScrollView(
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
                  sector.imageUrl,
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
              bottom: 32,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sector.title,
                        style: STStyles.header5,
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '2 tokens',
                          style: STStyles.body2Semibold.copyWith(
                            color: colors.gray10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ReadMoreText(
                    sector.description,
                    isCollapsed: ValueNotifier<bool>(true),
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
                controller: TextEditingController(),
                hintText: intl.showKycCountryPicker_search,
                onChanged: (value) {},
                height: 44,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
