import 'package:flutter/material.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../components/qr_button.dart';

class WithdrawTextField extends StatelessWidget {
  const WithdrawTextField({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.decoration,
    required this.onQrPressed,
  }) : super(key: key);

  final String title;
  final Function(String) onChanged;
  final InputDecoration decoration;
  final Function() onQrPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SpaceH5(),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: decoration,
              ),
            ),
            const SpaceW5(),
            QrButton(
              onPressed: onQrPressed,
            ),
          ],
        ),
      ],
    );
  }
}
