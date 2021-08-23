import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../market/view/components/header_text.dart';
import 'components/return_rates.dart';

class ReturnRatesBlock extends HookWidget {
  const ReturnRatesBlock({
    Key? key,
    required this.assetSymbol,
  }) : super(key: key);

  final String assetSymbol;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderText(
          text: 'Return Rates',
          textAlign: TextAlign.start,
        ),
        const SpaceH8(),
        ReturnRates(
          assetSymbol: assetSymbol,
        ),
        const Divider(),
      ],
    );
  }
}
