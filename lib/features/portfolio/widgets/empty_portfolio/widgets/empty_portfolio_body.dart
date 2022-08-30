import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyPortfolioBody extends StatelessObserverWidget {
  const EmptyPortfolioBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;
    final deviceSize = sDeviceSize;

    return SPaddingH24(
      child: Column(
        children: [
          const Spacer(),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              deviceSize.when(
                small: () {
                  return Image.asset(
                    simpleEllipseAsset,
                    width: 160,
                  );
                },
                medium: () {
                  return Image.asset(
                    simpleEllipseAsset,
                    width: 320,
                  );
                },
              ),
              Center(
                child: Text(
                  volumeFormat(
                    decimal: Decimal.zero,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                    prefix: baseCurrency.prefix,
                  ),
                  style: sTextH0Style.copyWith(
                    color: colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SpaceH42(),
          Text(
            intl.emptyEarnWalletBody_mainText1,
            textAlign: TextAlign.center,
            style: sTextH3Style,
          ),
          Text(
            intl.emptyEarnWalletBody_mainText2,
            textAlign: TextAlign.center,
            style: sTextH3Style.copyWith(
              color: colors.blue,
            ),
          ),
          const SpaceH70(),
          SPrimaryButton1(
            active: true,
            name: intl.emptyEarnWalletBody_buyWithCash,
            onTap: () {
              showBuyAction(
                shouldPop: false,
                fromCard: true,
                context: context,
                from: Source.profile,
              );
            },
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
