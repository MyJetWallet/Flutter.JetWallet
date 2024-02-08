import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/store/earn_store.dart';
import 'package:jetwallet/features/earn/widgets/basic_banner.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:jetwallet/features/earn/widgets/chips_suggestion_m.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card.dart';
import 'package:jetwallet/features/earn/widgets/price_header.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'EarnRouter')
class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  final ScrollController controller = ScrollController();

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Provider<EarnStore>(
      create: (context) => EarnStore(),
      child: Scaffold(
        body: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                backgroundColor: colors.white,
                pinned: true,
                elevation: 0,
                expandedHeight: 120,
                collapsedHeight: 120,
                primary: false,
                flexibleSpace: FadeOnScroll(
                  scrollController: controller,
                  fullOpacityOffset: 50,
                  fadeInWidget: const SDivider(
                    width: double.infinity,
                  ),
                  fadeOutWidget: const SizedBox.shrink(),
                  permanentWidget: SMarketHeaderClosed(
                    title: intl.earn_earn,
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              SBasicBanner(text: intl.earn_funds_are_calculated_based_on_the_current_value),
              SPriceHeader(
                //! Add to store
                totalSum: !getIt<AppStore>().isBalanceHide
                    //! Alex S. total ???
                    //! Add to store
                    ? volumeFormat(
                        decimal: sSignalRModules.earnWalletProfileData?.total ?? Decimal.zero,
                        symbol: sSignalRModules.baseCurrency.symbol,
                      )
                    : '**** ${sSignalRModules.baseCurrency.symbol}',
                revenueSum: !getIt<AppStore>().isBalanceHide
                    //! Alex S. how to get revenue ???
                    //! Add to store
                    ? volumeFormat(
                        decimal: sSignalRModules.earnWalletProfileData?.balance ?? Decimal.zero,
                        symbol: sSignalRModules.baseCurrency.symbol,
                      )
                    : '**** ${sSignalRModules.baseCurrency.symbol}',
              ),
              SBasicHeader(
                title: intl.earn_active_earns,
                buttonTitle: intl.earn_view_all,
                onTap: () {},
              ),
              ...[
                SDepositCard(),
                SDepositCard(),
              ],
              const SizedBox(height: 16),
              SBasicHeader(
                title: intl.earn_top_offers,
                buttonTitle: intl.earn_view_all,
                subtitle: intl.earn_most_profitable_earns,
                onTap: () {},
              ),
              //!
              Observer(
                builder: (context) {
                  final store = EarnStore.of(context);

                  return Column(
                    children: [
                      for (final offer in store.earnOffers)
                        Builder(
                          builder: (context) {
                            // currency.iconUr
                            // currency.description
                            // symbol
                            // accorancy
                            //  offer.apyRate %

                            final currency = sSignalRModules.currenciesList.firstWhere(
                              (currency) => currency.symbol == offer.assetId,
                            );
                            return ChipsSuggestionM(
                              percentage: 8.5,
                              cryptoName: currency.iconUrl,
                              onTap: () {},
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
