import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_light.dart';
import 'components/basic_bottom_sheet.dart';

void sShowBasicModalBottomSheet({
  Widget? pinned,
  Function(dynamic)? then,
  Function()? onDissmis,
  double? minHeight,
  Color? color,
  double? horizontalPadding,
  AnimationController? transitionAnimationController,
  Future<bool> Function()? onWillPop,
  bool expanded = false,
  bool removeBottomSheetBar = false,
  bool removeBarPadding = false,
  bool removePinnedPadding = false,
  bool scrollable = false,
  double? horizontalPinnedPadding,
  Widget? pinnedBottom,
  required List<Widget> children,
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasicBottomSheet(
        color: color ?? SColorsLight().white,
        transitionAnimationController: transitionAnimationController,
        pinned: pinned,
        horizontalPinnedPadding: horizontalPinnedPadding,
        onWillPop: onWillPop,
        onDissmis: onDissmis,
        minHeight: minHeight,
        horizontalPadding: horizontalPadding,
        expanded: expanded,
        removeBottomSheetBar: removeBottomSheetBar,
        removePinnedPadding: removePinnedPadding,
        removeBarPadding: removeBarPadding,
        scrollable: scrollable,
        pinnedBottom: pinnedBottom,
        children: children,
      );
    },
    transitionAnimationController: transitionAnimationController,
  ).then((value) => then?.call(value));
}
