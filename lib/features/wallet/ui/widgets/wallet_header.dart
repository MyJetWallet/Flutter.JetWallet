import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
    required this.curr,
    required this.pageController,
    required this.pageCount,
    this.isEurWallet = false,
  });

  final CurrencyModel curr;
  final PageController pageController;
  final int pageCount;
  final bool isEurWallet;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final baseCurrency = sSignalRModules.baseCurrency;

        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
        final fadeStart = max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return FlexibleSpaceBar(
          expandedTitleScale: 1,
          title: Opacity(
            opacity: opacity,
            child: SPaddingH24(
              child: Observer(
                warnWhenNoObservables: false,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SNetworkSvg24(
                            url: curr.iconUrl,
                          ),
                          const SpaceW8(),
                          Text(
                            curr.symbol,
                            style: sSubtitle2Style.copyWith(
                              color: sKit.colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SpaceH2(),
                      if (isEurWallet)
                        Text(
                          volumeFormat(
                            decimal: sSignalRModules.totalEurWalletBalance,
                            accuracy: curr.accuracy,
                            symbol: curr.symbol,
                          ),
                          style: sTextH2Style.copyWith(
                            color: sKit.colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (!isEurWallet)
                        Text(
                          curr.volumeBaseBalance(getIt.get<FormatService>().baseCurrency),
                          style: sTextH2Style.copyWith(
                            color: sKit.colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (baseCurrency.symbol != curr.symbol)
                        Text(
                          isEurWallet ? curr.volumeBaseBalance(baseCurrency) : curr.volumeAssetBalance,
                          style: sBodyText2Style.copyWith(
                            color: sKit.colors.grey1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SpaceH16(),
                      if (pageCount > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                              controller: pageController,
                              count: pageCount,
                              effect: ScrollingDotsEffect(
                                spacing: 2,
                                radius: 4,
                                dotWidth: 8,
                                dotHeight: 2,
                                maxVisibleDots: 11,
                                activeDotScale: 1,
                                dotColor: colors.black.withOpacity(0.1),
                                activeDotColor: colors.black,
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          titlePadding: const EdgeInsets.only(bottom: 18),
          background: Container(
            padding: EdgeInsets.only(
              top: 35,
              right: MediaQuery.of(context).size.width * .25,
            ),
            color: sKit.colors.extraLightBlue,
            alignment: Alignment.bottomLeft,
            width: double.infinity,
            child: Image.asset(
              simpleWalletCircle,
            ),
          ),
        );
      },
    );
  }
}
