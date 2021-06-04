import 'package:flutter/material.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../styles/amount_field_decoration.dart';

class ConvertAmountField extends StatelessWidget {
  const ConvertAmountField({
    Key? key,
    required this.symbol,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  final String symbol;
  final Function(String) onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40.0,
          width: 150.0,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: amountFieldDecoration.copyWith(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        const SpaceW5(),
        Text(
          symbol,
          style: const TextStyle(
            fontSize: 25.0,
          ),
        )
      ],
    );
  }
}
