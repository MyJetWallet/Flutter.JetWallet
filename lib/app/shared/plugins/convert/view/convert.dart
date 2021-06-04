import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/loader.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../screens/wallet/models/currency_model.dart';
import '../../../helpers/show_plain_snackbar.dart';
import '../notifier/convert_state.dart';
import '../notifier/convert_union.dart';
import '../provider/convert_notipod.dart';
import 'components/convert_amount_field.dart';
import 'components/convert_button.dart';
import 'components/convert_dropdown.dart';
import 'components/convert_response_quote/convert_response_quote.dart';
import 'components/convert_switch_button.dart';
import 'components/convert_title_text.dart';

class Convert extends HookWidget {
  const Convert({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(convertNotipod(currency));
    final notifier = useProvider(convertNotipod(currency).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert'),
      ),
      body: ProviderListener<ConvertState>(
        provider: convertNotipod(currency),
        onChange: (context, state) {
          state.union.maybeWhen(
            requestQuote: (error) {
              if (error != null) {
                showPlainSnackbar(context, error);
                notifier.cleanError();
              }
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          child: Padding(
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
                  controller: state.amountTextController,
                  symbol: state.from.symbol,
                  onChanged: (value) => notifier.updateAmount(value),
                ),
                const SpaceH10(),
                if (state.union is Loading) Loader(),
                if (state.union is RequestQuote)
                  ConvertButton(
                    name: 'Request Quote',
                    onPressed: () async => notifier.requestQuote(),
                  ),
                if (state.union is ResponseQuote)
                  ConvertResposneQuote(
                    state: state,
                    notifier: notifier,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
