import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionBottomSheetHeader extends StatelessWidget {
  const ActionBottomSheetHeader({
    Key? key,
    this.showSearch = false,
    this.showSearchWithArrow = false,
    this.hideTitle = false,
    this.showCloseIcon = true,
    this.removePadding = false,
    this.removeSearchPadding = false,
    this.onChanged,
    this.onCloseTap,
    required this.name,
  }) : super(key: key);

  final String name;
  final Function(String)? onChanged;
  final Function()? onCloseTap;
  final bool showSearch;
  final bool showSearchWithArrow;
  final bool hideTitle;
  final bool showCloseIcon;
  final bool removePadding;
  final bool removeSearchPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hideTitle)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: removePadding ? 0 : 24),
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
                if (showCloseIcon)
                  SIconButton(
                    onTap: () {
                      if (onCloseTap != null) {
                        onCloseTap!();
                      }

                      Navigator.pop(context);
                    },
                    defaultIcon: const SEraseIcon(),
                    pressedIcon: const SErasePressedIcon(),
                  ),
              ],
            ),
          ),
        if (showSearch) ...[
          if (removeSearchPadding)
            SStandardField(
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: onChanged,
            )
          else
            SPaddingH24(
              child: SStandardField(
                labelText: intl.actionBottomSheetHeader_search,
                onChanged: onChanged,
              ),
            ),
          const SDivider(),
        ] else if (showSearchWithArrow) ...[
          SPaddingH24(
            child: Row(
              children: [
                SizedBox(
                  height: 88,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpaceH20(),
                      SIconButton(
                        onTap: () => Navigator.pop(context),
                        defaultIcon: const SBackIcon(),
                        pressedIcon: const SBackPressedIcon(),
                      ),
                    ],
                  ),
                ),
                const SpaceW16(),
                Expanded(
                  child: SStandardField(
                    enableInteractiveSelection: false,
                    labelText: intl.actionBottomSheetHeader_searchAssets,
                    hideLabel: true,
                    onChanged: onChanged,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ] else
          const SpaceH24(),
      ],
    );
  }
}
