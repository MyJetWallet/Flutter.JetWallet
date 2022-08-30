import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/return_rates.dart';

class ReturnRatesBlock extends StatelessWidget {
  const ReturnRatesBlock({
    Key? key,
    required this.assetSymbol,
  }) : super(key: key);

  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SBaselineChild(
            baseline: 56,
            child: Text(
              intl.returnRatesBlock_returnRates,
              textAlign: TextAlign.start,
              style: sTextH4Style,
            ),
          ),
          ReturnRates(
            assetSymbol: assetSymbol,
          ),
        ],
      ),
    );
  }
}
