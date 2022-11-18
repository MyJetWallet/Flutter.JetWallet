import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/return_rates.dart';

class ReturnRatesBlock extends StatelessWidget {
  const ReturnRatesBlock({
    super.key,
    required this.assetSymbol,
  });

  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    final returnRates = sSignalRModules.getReturnRates(assetSymbol);

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (returnRates != null) ...[
            SBaselineChild(
              baseline: 56,
              child: Text(
                intl.returnRatesBlock_returnRates,
                textAlign: TextAlign.start,
                style: sTextH4Style,
              ),
            ),
          ] else ...[
            const SizedBox(
              height: 34,
            ),
          ],
          ReturnRates(
            assetSymbol: assetSymbol,
            returnRates: returnRates,
          ),
        ],
      ),
    );
  }
}
