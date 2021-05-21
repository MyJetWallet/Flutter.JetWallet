import 'package:flutter/material.dart';

import '../../../../shared/components/spacers.dart';
import '../../../screens/wallet/models/asset_with_balance_model.dart';
import 'components/deposit_field.dart';

class Deposit extends StatelessWidget {
  const Deposit({
    required this.currency,
  });

  final AssetWithBalanceModel currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deposit ${currency.description}',
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
