import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/currency_model.dart';

class FailedToFetchDepositAddress extends StatelessWidget {
  const FailedToFetchDepositAddress({
    Key? key,
    required this.currency,
    required this.onRetry,
  }) : super(key: key);

  final CurrencyModel currency;
  final Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              'Failed to fetch address',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: onRetry,
          icon: Icon(
            Icons.replay_outlined,
            size: 40.r,
          ),
        )
      ],
    );
  }
}
