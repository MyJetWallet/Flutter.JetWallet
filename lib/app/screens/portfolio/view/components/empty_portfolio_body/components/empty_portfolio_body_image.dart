import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../shared/helpers/formatting/formatting.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';

class EmptyPortfolioBodyImage extends HookWidget {
  const EmptyPortfolioBodyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final baseCurrency = useProvider(baseCurrencyPod);

    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          emptyPortfolioImageAsset,
          width: 280,
          height: 280,
        ),
        Text(
          volumeFormat(
            decimal: Decimal.zero,
            symbol: baseCurrency.symbol,
            prefix: baseCurrency.prefix,
            accuracy: baseCurrency.accuracy,
          ),
          style: sTextH0Style.copyWith(
            color: colors.white,
          ),
        ),
      ],
    );
  }
}
