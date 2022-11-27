import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/portfolio/helper/max_currency_apy.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnPinnedSmall extends StatelessObserverWidget {
  const EarnPinnedSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final currencies = sSignalRModules.currenciesList;

    return Stack(
      children: [
        SizedBox(
          height: 115,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${intl.earnBodyHeader_upTo} '
                            '${maxCurrencyApy(currencies).toStringAsFixed(0)}%',
                        style: sTextH5Style.copyWith(
                          color: colors.green,
                        ),
                      ),
                      TextSpan(
                        text: ' ${intl.earnBodyHeader_text1Part1}'
                            '\n${intl.earnBodyHeader_text1Part2}',
                        style: sTextH5Style.copyWith(
                          color: colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 33.0,
          right: 26.0,
          child: SIconButton(
            onTap: () => Navigator.pop(context),
            defaultIcon: const SErasePressedIcon(),
            pressedIcon: const SEraseMarketIcon(),
          ),
        ),
      ],
    );
  }
}
