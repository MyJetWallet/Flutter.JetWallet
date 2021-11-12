import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class AssetInputField extends StatelessWidget {
  const AssetInputField({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            value,
            maxLines: 1,
            style: sTextH1Style,
          ),
        ),
      ],
    );
  }
}
