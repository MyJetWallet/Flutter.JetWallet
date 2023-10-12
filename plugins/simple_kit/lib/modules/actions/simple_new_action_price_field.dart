import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../simple_kit.dart';

class SNewActionPriceField extends StatelessWidget {
  const SNewActionPriceField({
    Key? key,
    required this.primaryAmount,
    required this.primarySymbol,
    required this.secondaryAmount,
    required this.secondarySymbol,
    required this.widgetSize,
  }) : super(key: key);

  final String primaryAmount;
  final String primarySymbol;
  final String secondaryAmount;
  final String secondarySymbol;
  final SWidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SPaddingH24(
      child: SizedBox(
        height: widgetSize == SWidgetSize.small ? 116 : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText.rich(
              maxLines: 1,
              minFontSize: 1,
              TextSpan(
                text: primaryAmount,
                style: sTextH0Style.copyWith(
                  color: primaryAmount == '0' ? colors.grey3 : colors.black,
                  height: 0.8,
                ),
                children: [
                  TextSpan(
                    text: ' $primarySymbol',
                    style: sTextH2Style.copyWith(
                      color: primaryAmount == '0' ? colors.grey3 : colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceH4(),
            AutoSizeText(
              '$secondaryAmount $secondarySymbol',
              minFontSize: 4.0,
              maxLines: 1,
              style: sSubtitle3Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
