import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
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
        children: children,
      );
    },
    transitionAnimationController: transitionAnimationController,
  ).then((value) => then?.call(value));
}
