import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/components/loader.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../screens/wallet/model/currency_model.dart';
import '../provider/deposit_address_fpod.dart';
import 'components/deposit_field.dart';

class Deposit extends HookWidget {
  const Deposit({
    required this.currency,
  });

  final CurrencyModel currency;

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
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
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
                    const SpaceH15(),
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
