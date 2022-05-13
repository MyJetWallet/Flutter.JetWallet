import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/providers/service_providers.dart';
import 'components/return_rates.dart';

class ReturnRatesBlock extends HookWidget {
  const ReturnRatesBlock({
    Key? key,
    required this.assetSymbol,
  }) : super(key: key);

  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SBaselineChild(
            baseline: 56,
            child: Text(
              intl.returnRates,
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
