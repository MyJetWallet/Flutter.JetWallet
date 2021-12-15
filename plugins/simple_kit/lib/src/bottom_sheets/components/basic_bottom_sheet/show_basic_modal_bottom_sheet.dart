import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_light.dart';
import 'components/basic_bottom_sheet.dart';

void sShowBasicModalBottomSheet({
  Widget? pinned,
  Function(dynamic)? then,
  Function()? onDissmis,
  double? maxHeight,
  double? minHeight,
  Color? color,
  double? horizontalPadding,
  AnimationController? transitionAnimationController,
  Future<bool> Function()? onWillPop,
  bool removeBottomSheetBar = false,
  bool removeBottomHeaderPadding = false,
  bool removeTopHeaderPadding = false,
  bool scrollable = false,
  double? horizontalPinnedPadding,
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
        maxHeight: maxHeight,
        minHeight: minHeight,
        horizontalPadding: horizontalPadding,
        removeBottomSheetBar: removeBottomSheetBar,
        removeBottomHeaderPadding: removeBottomHeaderPadding,
        scrollable: scrollable,
        removeTopHeaderPadding: removeTopHeaderPadding,
        children: children,
      );
    },
    transitionAnimationController: transitionAnimationController,
  ).then((value) => then?.call(value));
}
