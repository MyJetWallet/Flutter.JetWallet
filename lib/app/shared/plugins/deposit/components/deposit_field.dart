import 'package:flutter/material.dart';

import '../../../components/qr_button.dart';

class DepositField extends StatelessWidget {
  const DepositField({
    Key? key,
    required this.name,
    required this.value,
    required this.onQrPressed,
  }) : super(key: key);

  final String name;
  final String value;
  final Function() onQrPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SelectableText(
          value,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        QrButton(
          onPressed: onQrPressed,
        ),
      ],
    );
  }
}
