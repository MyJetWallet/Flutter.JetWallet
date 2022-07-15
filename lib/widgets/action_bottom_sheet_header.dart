import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionBottomSheetHeader extends StatelessWidget {
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
              const Spacer(),
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
