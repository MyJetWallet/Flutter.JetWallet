import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class SBottomSheetHeader extends StatelessWidget {
  const SBottomSheetHeader({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Baseline(
          baseline: 20.0,
          baselineType: TextBaseline.alphabetic,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 72,
            child: Text(
              name,
              style: sTextH4Style,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}
