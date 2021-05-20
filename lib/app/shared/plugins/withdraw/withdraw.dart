import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';
import '../../models/currency_model.dart';
import 'components/amount_text_field.dart';
import 'components/withdraw_send_button.dart';
import 'components/withdraw_text_field.dart';
import 'styles/styles.dart';

class Withdraw extends StatelessWidget {
  const Withdraw({
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Withdraw ${currency.name}',
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
                onChanged: (value) {},
                onQrPressed: () {},
              ),
              const SpaceH20(),
              WithdrawTextField(
                title: 'Tag (memo)',
                decoration: widthdrawTagDecoration,
                onChanged: (value) {},
                onQrPressed: () {},
              ),
              const SpaceH20(),
              AmountTextField(
                title: 'Amount',
                onChanged: (value) {},
                decoration: widthdrawAmountDecoration,
              ),
              const SpaceH10(),
              WithdrawSendButton(
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
