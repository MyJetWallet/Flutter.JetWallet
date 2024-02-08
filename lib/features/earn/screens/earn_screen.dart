import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/ui/widgets/fade_on_scroll.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currencies_with_balance_from.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/20x20/public/checkmark/simple_checkmark_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

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

    return Scaffold(
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
        body: CustomRefreshIndicator(
          offsetToArmed: 75,
          onRefresh: () async {},
          builder: (
            BuildContext context,
            Widget child,
            IndicatorController controller,
          ) {
            return child;
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SBasicBanner(text: intl.earn_funds_are_calculated_based_on_the_current_value),
              SPriceHeader(
                totalSum: !getIt<AppStore>().isBalanceHide
                    ? _price(
                        //! Alex S. get earn total sum ?
                        currenciesWithBalanceFrom(sSignalRModules.currenciesList),
                        sSignalRModules.baseCurrency,
                      )
                    : '**** ${sSignalRModules.baseCurrency.symbol}',
                revenueSum: !getIt<AppStore>().isBalanceHide
                    ? _price(
                        //! Alex S. get earn Revenue price ?
                        currenciesWithBalanceFrom(sSignalRModules.currenciesList),
                        sSignalRModules.baseCurrency,
                      )
                    : '**** ${sSignalRModules.baseCurrency.symbol}',
              ),
              SBasicHeader(
                title: intl.earn_active_earns,
                buttonTitle: intl.earn_view_all,
                onTap: () {},
              ),
              SCryptoCard(),
            ],
          ),
        ),
      ),
    );
  }

  String _price(
    List<CurrencyModel> items,
    BaseCurrencyModel baseCurrency,
  ) {
    var totalBalance = Decimal.zero;

    for (final item in items) {
      totalBalance += item.baseBalance;
    }

    return volumeFormat(
      decimal: totalBalance,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );
  }
}

class SCryptoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE0E4EA)),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cryptoCardHeader(),
              const SizedBox(height: 16),
              _cryptoCardBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cryptoCardHeader() {
    return const Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.currency_bitcoin, color: Colors.white),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Bitcoin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right_sharp),
                ],
              ),
              Text(
                'Variable APY 17.23%',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SCardBadge(
          text: 'Earning',
          status: SCardBadgeStatus.success,
        ),
      ],
    );
  }

  Widget _cryptoCardBody() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '14.43 EUR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '0.365 BTC',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 24),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '92.12 EUR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '0.00234 BTC',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SCardBadgeStatus {
  primary,
  success,
  error,
  pending,
}

class SCardBadge extends StatelessWidget {
  const SCardBadge({
    super.key,
    required this.status,
    required this.text,
    this.isLoading = false,
  });

  final SCardBadgeStatus status;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: getBGColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLoading)
            SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: getMainColor,
              ),
            )
          else
            status == SCardBadgeStatus.error
                ? _buildDot(
                    color: getMainColor,
                  )
                : status == SCardBadgeStatus.pending
                    ? _buildDot(
                        color: getMainColor,
                      )
                    : _buildDot(
                        color: getMainColor,
                      ),
          const SizedBox(width: 4),
          Text(
            text,
            style: sBodyText1Style.copyWith(
              height: 1,
              color: getMainColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required Color color}) {
    return Container(
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Color get getBGColor {
    switch (status) {
      case SCardBadgeStatus.primary:
        return SColorsLight().blueExtraLight;
      case SCardBadgeStatus.pending:
        return SColorsLight().grey5;
      case SCardBadgeStatus.success:
        return SColorsLight().greenExtraLight;
      case SCardBadgeStatus.error:
        return SColorsLight().redExtraLight;
      default:
        return SColorsLight().blueExtraLight;
    }
  }

  Color get getMainColor {
    switch (status) {
      case SCardBadgeStatus.primary:
        return SColorsLight().blue;
      case SCardBadgeStatus.pending:
        return SColorsLight().grey1;
      case SCardBadgeStatus.success:
        return SColorsLight().green;
      case SCardBadgeStatus.error:
        return SColorsLight().red;
      default:
        return SColorsLight().blueExtraLight;
    }
  }
}

class SBasicHeader extends StatelessWidget {
  const SBasicHeader({
    required this.title,
    this.buttonTitle,
    this.onTap,
    super.key,
  });

  final String title;
  final String? buttonTitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: sTextH4Style,
          ),
          if (onTap != null && buttonTitle != null)
            GestureDetector(
              onTap: onTap,
              child: Text(
                buttonTitle!,
                style: STStyles.button.copyWith(color: SColorsLight().blue),
              ),
            ),
        ],
      ),
    );
  }
}

class SPriceHeader extends StatelessWidget {
  const SPriceHeader({
    required this.totalSum,
    required this.revenueSum,
    super.key,
  });

  final String totalSum;
  final String revenueSum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            intl.rewards_total,
            style: STStyles.subtitle1.copyWith(
              color: SColorsLight().black,
            ),
          ),
          Text(
            totalSum,
            style: STStyles.header3.copyWith(
              color: SColorsLight().black,
            ),
          ),
          Text(
            '${intl.earn_revenue} $revenueSum',
            style: STStyles.body1Semibold.copyWith(
              color: SColorsLight().grey1,
            ),
          ),
        ],
      ),
    );
  }
}

class SBasicBanner extends StatelessWidget {
  const SBasicBanner({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.yellowLight,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SInfoIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: STStyles.body2Medium.copyWith(
                  color: SColorsLight().black,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
