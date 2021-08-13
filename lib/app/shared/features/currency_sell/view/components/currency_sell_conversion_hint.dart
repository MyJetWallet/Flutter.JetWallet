import 'package:flutter/material.dart';

import '../../../../components/text/asset_conversion_text.dart';

class CurrencySellConversionHint extends StatelessWidget {
  const CurrencySellConversionHint({
    Key? key,
    required this.available,
    required this.targetConversion,
    required this.baseConversion,
  }) : super(key: key);

  final String available;
  final String targetConversion;
  final String baseConversion;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AssetConversionText(
          text: 'Available: $available ',
        ),
        Expanded(
          child: AssetConversionText(
            textAlign: TextAlign.end,
            text: '≈ $targetConversion ($baseConversion)',
          ),
        ),
      ],
    );
  }
}
