import 'package:flutter/material.dart';

import '../../../colors/view/simple_colors_light.dart';
import 'components/basic_bottom_sheet.dart';

void sShowBasicBottomSheet({
  Widget? pinned,
  Function()? onDissmis,
  double? maxHeight,
  double? minHeight,
  Color? color,
  double? horizontalPadding,
  Function()? whenColmplete,
  AnimationController? transitionAnimationController,
  Future<bool> Function()? onWillPop,
  bool removeBottomSheetBar = true,
  bool removeBottomHeaderPadding = false,
  required List<Widget> children,
  required BuildContext context,
}) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasicBottomSheet(
        color: color ?? SColorsLight().white,
        transitionAnimationController: transitionAnimationController,
        pinned: pinned,
        onWillPop: onWillPop,
        onDissmis: onDissmis,
        maxHeight: maxHeight,
        minHeight: minHeight,
        horizontalPadding: horizontalPadding,
        removeBottomSheetBar: removeBottomSheetBar,
        removeBottomHeaderPadding: removeBottomHeaderPadding,
        scrollable: false,
        children: children,
      );
    },
    transitionAnimationController: transitionAnimationController,
  ).closed.whenComplete(() => whenColmplete?.call());
}
