import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SBottomSheetHeader extends StatelessWidget {
  const SBottomSheetHeader({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Baseline(
          baseline: 20.0,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            name,
            style: sTextH4Style,
          ),
        ),
        const Spacer(),
        SIconButton(
          onTap: () => Navigator.pop(context),
          defaultIcon: const SEraseIcon(),
          pressedIcon: const SErasePressedIcon(),
        ),
      ],
    );
  }
}
