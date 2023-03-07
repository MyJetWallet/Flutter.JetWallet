import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/show_start_earn_options.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../earn_bottom_sheet/earn_bottom_sheet.dart';
import 'components/empty_apy_portfolio_body_image.dart';
import 'components/empty_apy_portfolio_body_title.dart';

class EmptyApyPortfolioBody extends StatelessObserverWidget {
  const EmptyApyPortfolioBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    return SPaddingH24(
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Text(
                    volumeFormat(
                      decimal: Decimal.zero,
                      accuracy: baseCurrency.accuracy,
                      symbol: baseCurrency.symbol,
                      prefix: baseCurrency.prefix,
                    ),
                    style: sTextH1Style,
                  ),
                ),
                Column(
                  children: [
                    const Spacer(),
                    const EmptyPortfolioBodyImage(),
                    const Spacer(),
                    const EmptyPortfolioBodyTitle(),
                    const SpaceH17(),
                    Text(
                      '${intl.emptyPortfolioBody_cryptoWorkForYou}!\n'
                      '${intl.emptyPortfolioBody_text1Part2}.',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                    const SpaceH40(),
                    SPrimaryButton1(
                      active: true,
                      name: intl.emptyPortfolioBody_startEarn,
                      onTap: () {
                        showStartEarnBottomSheet(
                          context: context,
                          onTap: (CurrencyModel currency) {
                            Navigator.pop(context);

                            showStartEarnOptions(
                              currency: currency,
                            );
                          },
                        );
                      },
                    ),
                    const SpaceH24(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
