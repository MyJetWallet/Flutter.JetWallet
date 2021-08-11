import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../../../shared/components/spacers.dart';
import '../model/selected_percent.dart';
import 'components/percent_box.dart';

class PercentSelector extends HookWidget {
  const PercentSelector({
    Key? key,
    required this.disabled,
    required this.onSelection,
  }) : super(key: key);

  final bool disabled;
  final Function(SelectedPercent) onSelection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PercentBox(
          name: '25%',
          onTap: () => onSelection(SelectedPercent.pct25),
          disabled: disabled,
        ),
        const SpaceW10(),
        PercentBox(
          name: '50%',
          onTap: () => onSelection(SelectedPercent.pct50),
          disabled: disabled,
        ),
        const SpaceW10(),
        PercentBox(
          name: '100%',
          onTap: () => onSelection(SelectedPercent.pct100),
          disabled: disabled,
        ),
      ],
    );
  }
}
