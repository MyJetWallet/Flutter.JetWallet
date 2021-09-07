import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../notifier/withdrawal_address_notifier/address_validation_union.dart';

class WithdrawalAddressValidator extends StatelessWidget {
  const WithdrawalAddressValidator({
    Key? key,
    this.withTag = false,
    required this.symbol,
    required this.validation,
  }) : super(key: key);

  final bool withTag;
  final String symbol;
  final AddressValidationUnion validation;

  @override
  Widget build(BuildContext context) {
    final name = withTag ? 'Tag' : 'Address';
    final result = validation is Valid ? 'Valid' : 'Invalid';

    return Row(
      children: [
        if (validation is Invalid) ...[
          Icon(
            Icons.close,
            size: 18.r,
            color: Colors.black,
          ),
        ] else if (validation is Loading) ...[
          SizedBox(
            width: 14.w,
            height: 14.w,
            child: CircularProgressIndicator(
              strokeWidth: 1.w,
              color: Colors.black,
            ),
          ),
        ] else ...[
          Icon(
            Icons.check,
            size: 18.r,
            color: Colors.black,
          ),
        ],
        const SpaceW4(),
        Text(
          '$result $symbol $name',
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
