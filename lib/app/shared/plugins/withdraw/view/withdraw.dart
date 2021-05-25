import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/spacers.dart';
import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../../../styles/amount_field_decoration.dart';
import '../notifiers/state/withdraw_state.dart';
import '../providers/withdraw_notipod.dart';
import 'components/amount_text_field.dart';
import 'components/withdraw_send_button.dart';
import 'components/withdraw_text_field.dart';
import 'styles/styles.dart';

class Withdraw extends HookWidget {
  const Withdraw({
    required this.currency,
  });

  final AssetWithBalanceModel currency;

  @override
  Widget build(BuildContext context) {
    final withdrawNotifier = useProvider(
      withdrawNotipod(currency.symbol).notifier,
    );

    return ProviderListener<WithdrawState>(
      provider: withdrawNotipod(currency.symbol),
      onChange: (context, state) {
        state.union.when(
          input: (e, st) {
            if (e != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          loading: () {},
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Withdraw ${currency.description}',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WithdrawTextField(
                  title: 'Addres',
                  decoration: widthdrawAddressDecoration,
                  onChanged: (value) => withdrawNotifier.updateAddress(value),
                  onQrPressed: () {},
                ),
                const SpaceH20(),
                if (currency.tagType == 1)
                  WithdrawTextField(
                    title: 'Tag (memo)',
                    decoration: widthdrawTagDecoration,
                    onChanged: (value) => withdrawNotifier.updateMemo(value),
                    onQrPressed: () {},
                  ),
                const SpaceH20(),
                AmountTextField(
                  title: 'Amount',
                  onChanged: (value) => withdrawNotifier.updateAmount(value),
                  decoration: amountFieldDecoration,
                ),
                const SpaceH10(),
                WithdrawSendButton(
                  onPressed: () async {
                    final success = await withdrawNotifier.withdraw();

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Withdrawn Success')),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
