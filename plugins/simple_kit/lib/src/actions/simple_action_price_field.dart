import 'package:flutter/material.dart';

import 'components/simple_medium_action_price_field.dart';
import 'components/simple_small_action_price_field.dart';

class SActionPriceField extends StatelessWidget {
  const SActionPriceField({
    Key? key,
    required this.price,
    required this.helper,
    required this.error,
    required this.isErrorActive,
    required this.isSmall,
  }) : super(key: key);

  final String price;
  final String helper;
  final String error;
  final bool isErrorActive;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      return SSmallActionPriceField(
        price: price,
        error: error,
        helper: helper,
        isErrorActive: isErrorActive,
      );
    } else {
      return SMediumActionPriceField(
        price: price,
        error: error,
        helper: helper,
        isErrorActive: isErrorActive,
      );
    }
  }
}
