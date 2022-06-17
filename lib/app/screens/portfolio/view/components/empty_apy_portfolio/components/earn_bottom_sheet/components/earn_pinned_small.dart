import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../../../../../../helper/max_currency_apy.dart';

class EarnPinnedSmall extends HookWidget {
  const EarnPinnedSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final currencies = useProvider(currenciesPod);
    final intl = useProvider(intlPod);

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
