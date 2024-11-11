import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ActionBottomSheetHeader extends StatefulWidget {
  const ActionBottomSheetHeader({
    super.key,
    this.showSearch = false,
    this.showSearchWithArrow = false,
    this.hideTitle = false,
    this.removePadding = false,
    this.removeSearchPadding = false,
    this.needBottomPadding = true,
    this.onChanged,
    required this.name,
    this.horizontalDividerPadding = 0,
    this.isNewDesign = false,
    this.addPaddingBelowTitle = false,
  });

  final String name;
  final Function(String)? onChanged;
  final bool showSearch;
  final bool showSearchWithArrow;
  final bool hideTitle;
  final bool removePadding;
  final bool removeSearchPadding;
  final bool needBottomPadding;
  final bool addPaddingBelowTitle;
  final double horizontalDividerPadding;
  // TODO(yaroslav): migrate to the new design in all places.
  final bool isNewDesign;

  @override
  State<ActionBottomSheetHeader> createState() => _ActionBottomSheetHeaderState();
}

class _ActionBottomSheetHeaderState extends State<ActionBottomSheetHeader> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.hideTitle)
          Padding(
            padding: EdgeInsets.only(
              left: widget.removePadding ? 0 : 24,
              right: widget.removePadding ? 0 : 24,
              top: widget.isNewDesign ? 6 : 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Baseline(
                  baseline: 20.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    widget.name,
                    style: STStyles.header5,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        if (widget.addPaddingBelowTitle) const SpaceH26(),
        if (widget.showSearch) ...[
          if (widget.removeSearchPadding)
            SStandardField(
              controller: textController,
              labelText: intl.actionBottomSheetHeader_search,
              onChanged: widget.onChanged,
              maxLines: 1,
            )
          else if (widget.isNewDesign)
            Container(
              transform: Matrix4.translationValues(0.0, 3, 0.0),
              child: SPaddingH24(
                child: SStandardField(
                  controller: textController,
                  hintText: intl.actionBottomSheetHeader_search,
                  onChanged: widget.onChanged,
                  maxLines: 1,
                  height: 44,
                ),
              ),
            )
          else
            SPaddingH24(
              child: SStandardField(
                controller: textController,
                labelText: intl.actionBottomSheetHeader_search,
                onChanged: widget.onChanged,
                maxLines: 1,
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalDividerPadding,
            ),
            child: const SDivider(),
          ),
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
                    maxLines: 1,
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
