import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../shared/helpers/format_currency_string_amount.dart';
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
          width: 280.r,
          height: 280.r,
        ),
        Text(
          formatCurrencyStringAmount(
            value: '0',
            symbol: baseCurrency.symbol,
            prefix: baseCurrency.prefix,
          ),
          style: sTextH0Style.copyWith(
            color: colors.white,
          ),
        ),
      ],
    );
  }
}
