import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/portfolio/helper/max_currency_apy.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnBodyHeader extends StatelessWidget {
  const EarnBodyHeader({
    Key? key,
    required this.colors,
    required this.currencies,
  }) : super(key: key);

  final SimpleColors colors;
  final List<CurrencyModel> currencies;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        Flexible(
          child: AutoSizeText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${intl.earnBodyHeader_upTo} '
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
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
