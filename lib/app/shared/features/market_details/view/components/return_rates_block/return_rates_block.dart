import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/return_rates.dart';

class ReturnRatesBlock extends HookWidget {
  const ReturnRatesBlock({
    Key? key,
    required this.assetSymbol,
    required this.associateAssetPair,
  }) : super(key: key);

  final String assetSymbol;
  final String associateAssetPair;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56.h,
            child: Baseline(
              baseline: 50.h,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                'Return Rates',
                textAlign: TextAlign.start,
                style: sTextH4Style,
              ),
            ),
          ),
          ReturnRates(
            assetSymbol: assetSymbol,
            associateAssetPair: associateAssetPair,
          ),
          const SpaceH12(),
          const SDivider(),
        ],
      ),
    );
  }
}
