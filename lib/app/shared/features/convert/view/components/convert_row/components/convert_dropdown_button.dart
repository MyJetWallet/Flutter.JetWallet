import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

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
          NetworkSvgW24(
            url: currency.iconUrl,
          ),
          const SpaceW10(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 89.w,
            ),
            child: Text(
              currency.symbol,
              maxLines: 1,
              style: sTextH4Style,
            ),
          ),
          const SpaceW10(),
          const SAngleDownIcon(),
        ],
      ),
    );
  }
}
