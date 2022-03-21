import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../provider/action_buy_filtered_stpod.dart';

class ActionBottomSheetHeader extends HookWidget {
  const ActionBottomSheetHeader({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final actionBuyFiltered = useProvider(actionBuyFilteredStpod);

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
            onChanged: (value) {
              actionBuyFiltered.state = value;
            },
          ),
        ),
        const SDivider(),
      ],
    );
  }
}
