import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/spacers.dart';
import '../../../../screens/market/model/currency_model.dart';
import '../../../styles/amount_field_decoration.dart';
import '../notifier/withdraw_notipod.dart';
import '../notifier/withdraw_state.dart';
import 'components/amount_text_field.dart';
import 'components/withdraw_send_button.dart';
import 'components/withdraw_text_field.dart';
import 'styles/styles.dart';

class CurrencyWithdraw extends HookWidget {
  const CurrencyWithdraw({
    required this.currency,
  });

  final CurrencyModel currency;

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
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WithdrawTextField(
                  title: 'Addres',
                  decoration: widthdrawAddressDecoration,
                  onChanged: (value) => withdrawNotifier.updateAddress(value),
                  onQrPressed: () {},
                ),
                const SpaceH15(),
                if (currency.tagType == 1)
                  WithdrawTextField(
                    title: 'Tag (memo)',
                    decoration: widthdrawTagDecoration,
                    onChanged: (value) => withdrawNotifier.updateMemo(value),
                    onQrPressed: () {},
                  ),
                const SpaceH15(),
                AmountTextField(
                  title: 'Amount',
                  onChanged: (value) => withdrawNotifier.updateAmount(value),
                  decoration: amountFieldDecoration,
                ),
                const SpaceH8(),
                WithdrawSendButton(
                  onPressed: () async {
                    final success = await withdrawNotifier.withdraw();

                    if (success) {
                      // ignore: use_build_context_synchronously
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
