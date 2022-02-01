import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = useProvider(sColorPod);
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Up to ${maxCurrencyApy(currencies).toStringAsFixed(0)}%',
                style: sTextH3Style.copyWith(
                  color: colors.green,
                ),
              ),
              TextSpan(
                text: ' interest\non deposited crypto',
                style: sTextH3Style.copyWith(
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
