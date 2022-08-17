import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';

class ActionBottomSheetHeader extends HookWidget {
  const ActionBottomSheetHeader({
    Key? key,
    this.showSearch = false,
    this.onChanged,
    required this.name,
  }) : super(key: key);

  final String name;
  final Function(String)? onChanged;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Column(
      children: [
        SPaddingH24(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    name,
                    style: sTextH4Style,
                    maxLines: 2,
                  ),
                ),
              ),
              if (!showSearch)
                SIconButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  defaultIcon: const SEraseIcon(),
                  pressedIcon: const SErasePressedIcon(),
                ),
            ],
          ),
        ),
        if (showSearch) ...[
          SPaddingH24(
            child: SStandardField(
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: onChanged,
            ),
          ),
          const SDivider(),
        ] else
          const SpaceH24(),
      ],
    );
  }
}
