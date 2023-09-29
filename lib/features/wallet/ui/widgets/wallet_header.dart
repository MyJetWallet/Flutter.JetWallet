import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key, required this.curr});

  final CurrencyModel curr;

  @override
  Widget build(BuildContext context) {
    final isInProgress = curr.assetBalance == Decimal.zero && curr.isPendingDeposit;

    return LayoutBuilder(
      builder: (context, c) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0) as double;
        final fadeStart = max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return FlexibleSpaceBar(
          expandedTitleScale: 1,
          title: Opacity(
            opacity: 1,
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
                      Text(
                        isInProgress
                            ? '${intl.walletCard_balanceInProcess}...'
                            : curr.volumeBaseBalance(getIt.get<FormatService>().baseCurrency),
                        style: sTextH2Style.copyWith(
                          color: sKit.colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        curr.volumeAssetBalance,
                        style: sBodyText2Style.copyWith(
                          color: sKit.colors.grey1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          titlePadding: const EdgeInsets.only(bottom: 32),
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
