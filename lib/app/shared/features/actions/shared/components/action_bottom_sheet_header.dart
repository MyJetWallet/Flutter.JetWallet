import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionBottomSheetHeader extends StatelessWidget {
  const ActionBottomSheetHeader({
    Key? key,
    required this.name,
    required this.onChanged,
  }) : super(key: key);

  final String name;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SPaddingH24(
          child: Row(
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
            ],
          ),
        ),
        SPaddingH24(
          child: SStandardField(
            autofocus: true,
            labelText: 'Search',
            onChanged: onChanged,
          ),
        ),
        const SDivider(),
      ],
    );
  }
}
