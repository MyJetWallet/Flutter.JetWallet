import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../../shared/components/spacers.dart';
import '../model/selected_percent.dart';
import '../notifier/percent_selector_notipod.dart';
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
    final selectorN = useProvider(percentSelectorNotipod.notifier);

    return Row(
      children: [
        PercentBox(
          name: '25%',
          onTap: () {
            final result = selectorN.update(SelectedPercent.pct25);
            onSelection(result);
          },
          disabled: disabled,
        ),
        const SpaceW10(),
        PercentBox(
          name: '50%',
          onTap: () {
            final result = selectorN.update(SelectedPercent.pct50);
            onSelection(result);
          },
          disabled: disabled,
        ),
        const SpaceW10(),
        PercentBox(
          name: '100%',
          onTap: () {
            final result = selectorN.update(SelectedPercent.pct100);
            onSelection(result);
          },
          disabled: disabled,
        ),
      ],
    );
  }
}
