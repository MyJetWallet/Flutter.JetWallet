import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/spacers.dart';
import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../provider/convert_notipod.dart';
import 'components/convert_amount_field.dart';
import 'components/convert_dropdown.dart';
import 'components/convert_switch_button.dart';
import 'components/convert_title_text.dart';
import 'components/request_quote_button.dart';

class Convert extends HookWidget {
  const Convert({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final AssetWithBalanceModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(convertNotipod(currency));
    final notifier = useProvider(convertNotipod(currency).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ConvertTitleText(
              text: 'From',
            ),
            ConvertDropdown(
              value: state.from,
              currencies: state.fromList,
              onChanged: (value) => notifier.updateFrom(value!),
            ),
            const SpaceH10(),
            ConvertSwitchButton(
              onChanged: () => notifier.switchFromTo(),
            ),
            const SpaceH20(),
            const ConvertTitleText(
              text: 'To',
            ),
            ConvertDropdown(
              value: state.to,
              currencies: state.toList,
              onChanged: (value) => notifier.updateTo(value!),
            ),
            const SpaceH20(),
            ConvertAmountField(
              symbol: state.from.symbol,
              onChanged: (value) => notifier.updateAmount(value),
            ),
            const SpaceH10(),
            RequestQuoteButton(
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
