import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/loader.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../providers/deposit_address_fpod.dart';
import 'components/deposit_field.dart';

class Deposit extends HookWidget {
  const Deposit({
    required this.currency,
  });

  final AssetWithBalanceModel currency;

  @override
  Widget build(BuildContext context) {
    final depositAddress = useProvider(
      depositAddressFpod(currency.symbol),
    );

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
            depositAddress.when(
              data: (data) {
                return Column(
                  children: [
                    DepositField(
                      name: 'Address',
                      value: data.address ?? 'The addres is Null',
                      onQrPressed: () {},
                    ),
                    const SpaceH20(),
                    if (data.memo != null)
                      DepositField(
                        name: 'Tag',
                        value: data.memo.toString(),
                        onQrPressed: () {},
                      ),
                  ],
                );
              },
              loading: () => Loader(),
              error: (e, st) => Text('$e'),
            ),
          ],
        ),
      ),
    );
  }
}
