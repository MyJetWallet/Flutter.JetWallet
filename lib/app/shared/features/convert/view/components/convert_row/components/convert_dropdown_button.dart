import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../models/currency_model.dart';

class ConvertDropdownButton extends StatelessWidget {
  const ConvertDropdownButton({
    Key? key,
    required this.onTap,
    required this.currency,
  }) : super(key: key);

  final Function() onTap;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.network(
            currency.iconUrl,
            width: 35.w,
            height: 35.w,
          ),
          const SpaceW10(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.25.sw,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                currency.symbol,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SpaceW4(),
          FittedBox(
            child: Icon(
              FontAwesomeIcons.angleDown,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}
