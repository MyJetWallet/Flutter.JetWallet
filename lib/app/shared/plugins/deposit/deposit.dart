import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';
import '../../models/currency_model.dart';
import 'components/deposit_field.dart';

class Deposit extends StatelessWidget {
  const Deposit({
    required this.currency,
  });

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deposit ${currency.name}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DepositField(
              name: 'Address',
              value: '0x32Be343B94f860124dC4fEe278FDCBD38C102D88',
              onQrPressed: () {},
            ),
            const SpaceH20(),
            DepositField(
              name: 'Tag',
              value: '32489328',
              onQrPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
