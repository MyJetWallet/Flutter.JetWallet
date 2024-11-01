import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import 'components/basic_bottom_sheet.dart';

void sShowBasicModalBottomSheet({
  Widget? pinned,
  Function(dynamic)? then,
  Function()? onDissmis,
  double? minHeight,
  Color? color,
  double? horizontalPadding,
  AnimationController? transitionAnimationController,
  Future Function(bool)? onWillPop,
  bool expanded = false,
  bool enableDrag = true,
  bool isDismissible = true,
  bool removeBottomSheetBar = false,
  bool removeBarPadding = false,
  bool removePinnedPadding = false,
  bool scrollable = false,
  bool fullScreen = false,
  bool isInvest = false,
  double? horizontalPinnedPadding,
  Widget? pinnedBottom,
  required List<Widget> children,
  required BuildContext context,
}) {
  showMaterialModalBottomSheet(
    context: context,
    //shadow: const BoxShadow(color: Colors.transparent),
    backgroundColor: Colors.transparent,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    barrierColor: Colors.black54,
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
        fullScreen: fullScreen,
        isInvest: isInvest,
        isDismissible: isDismissible,
        pinnedBottom: pinnedBottom,
        children: children,
      );
    },
  ).then((value) {
    then?.call(value);
  });
}
