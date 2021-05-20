import 'package:flutter/material.dart';

import '../../../../../shared/components/spacers.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.decoration,
  }) : super(key: key);

  final String title;
  final Function(String) onChanged;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        SizedBox(
          width: size.width * 0.4,
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: decoration,
          ),
        ),
      ],
    );
  }
}
