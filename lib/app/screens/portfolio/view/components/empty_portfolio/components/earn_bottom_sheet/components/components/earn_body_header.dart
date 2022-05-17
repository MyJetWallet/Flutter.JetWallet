import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../../shared/models/currency_model.dart';
import '../../../../../../../helper/max_currency_apy.dart';

class EarnBodyHeader extends HookWidget {
  const EarnBodyHeader({
    Key? key,
    required this.colors,
    required this.currencies,
  }) : super(key: key);

  final SimpleColors colors;
  final List<CurrencyModel> currencies;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${intl.upTo} '
                    '${maxCurrencyApy(currencies).toStringAsFixed(0)}%',
                style: sTextH2Style.copyWith(
                  color: colors.green,
                ),
              ),
              TextSpan(
                text: ' ${intl.earnBodyHeader_text1Part1}\n'
                    '${intl.earnBodyHeader_text1Part2}',
                style: sTextH2Style.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
