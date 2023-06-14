import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ActionBottomSheetHeader extends StatefulWidget {
  const ActionBottomSheetHeader({
    Key? key,
    this.showSearch = false,
    this.showSearchWithArrow = false,
    this.hideTitle = false,
    this.showCloseIcon = true,
    this.removePadding = false,
    this.removeSearchPadding = false,
    this.needBottomPadding = true,
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
  final bool needBottomPadding;

  @override
  State<ActionBottomSheetHeader> createState() =>
      _ActionBottomSheetHeaderState();
}

class _ActionBottomSheetHeaderState extends State<ActionBottomSheetHeader> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.hideTitle)
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.removePadding ? 0 : 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Baseline(
                    baseline: 20.0,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      widget.name,
                      style: sTextH4Style,
                      maxLines: 2,
                    ),
                  ),
                ),
                if (widget.showCloseIcon)
                  SIconButton(
                    onTap: () {
                      if (widget.onCloseTap != null) {
                        widget.onCloseTap!();
                      }

                      Navigator.pop(context);
                    },
                    defaultIcon: const SEraseIcon(),
                    pressedIcon: const SErasePressedIcon(),
                  ),
              ],
            ),
          ),
        if (widget.showSearch) ...[
          if (widget.removeSearchPadding)
            SStandardField(
              controller: textController,
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: widget.onChanged,
            )
          else
            SPaddingH24(
              child: SStandardField(
                controller: textController,
                labelText: intl.actionBottomSheetHeader_search,
                onChanged: widget.onChanged,
              ),
            ),
          const SDivider(),
        ] else if (widget.showSearchWithArrow) ...[
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
                    controller: TextEditingController(),
                    enableInteractiveSelection: false,
                    labelText: intl.actionBottomSheetHeader_searchAssets,
                    hideLabel: true,
                    onChanged: widget.onChanged,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          if (widget.needBottomPadding) ...[
            const SpaceH24(),
          ],
        ],
      ],
    );
  }
}
