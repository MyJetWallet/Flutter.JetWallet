import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../model/currency_model.dart';

const _temp = 'https://i.imgur.com/cvNa7tH.png';

class CurrencyCard extends StatelessWidget {
  const CurrencyCard({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: Image.network(_temp),
          ),
          const SpaceW8(),
          Text(
            currency.description,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${currency.assetBalance} ${currency.symbol}'),
              Text(
                currency.baseBalance == -1
                    ? 'unknown'
                    : 'USD ${currency.baseBalance}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
