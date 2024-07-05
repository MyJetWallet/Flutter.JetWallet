import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import 'components/basic_bottom_sheet.dart';

void sShowBasicBottomSheet({
  Widget? pinned,
  Function()? onDissmis,
  double? minHeight,
  Color? color,
  double? horizontalPadding,
  Function()? whenColmplete,
  AnimationController? transitionAnimationController,
  Future Function(bool)? onWillPop,
  bool removeBottomSheetBar = true,
  bool removePinnedPadding = false,
  Widget? pinnedBottom,
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
        minHeight: minHeight,
        horizontalPadding: horizontalPadding,
        removeBottomSheetBar: removeBottomSheetBar,
        removePinnedPadding: removePinnedPadding,
        scrollable: false,
        pinnedBottom: pinnedBottom,
        children: children,
      );
    },
    transitionAnimationController: transitionAnimationController,
  ).closed.whenComplete(() => whenColmplete?.call());
}
