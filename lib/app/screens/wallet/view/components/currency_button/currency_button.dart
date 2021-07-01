import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/features/currency_details/currency_details.dart';
import '../../../model/currency_model.dart';
import 'components/currency_card.dart';

class CurrencyButton extends StatelessWidget {
  const CurrencyButton({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => navigatorPush(
        context,
        CurrencyDetails(currency: currency),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
        ),
        child: CurrencyCard(
          currency: currency,
        ),
      ),
    );
  }
}
