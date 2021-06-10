import 'package:flutter/material.dart';

import '../../../../../shared/features/currency_details/currency_details.dart';
import '../../../../../shared/helpers/navigator_push.dart';
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
      borderRadius: BorderRadius.circular(20.0),
      onTap: () => navigatorPush(
        context,
        CurrencyDetails(currency: currency),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: CurrencyCard(
          currency: currency,
        ),
      ),
    );
  }
}
