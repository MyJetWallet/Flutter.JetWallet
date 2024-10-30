import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showBasicBottomSheet({
  required BuildContext context,
  required List<Widget> children,
  BasicBottomSheetHeaderWidget basicBottomSheetHeader = const BasicBottomSheetHeaderWidget(),
  BasicBottomSheetButton? basicBottomSheetButton,
  Function()? onDismiss,
  bool isDismissible = true,
  Future Function(bool)? onWillPop,
  Color? color,
  String? title,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return BasicBottomSheet(
        header: basicBottomSheetHeader,
        button: basicBottomSheetButton,
        onDismiss: onDismiss,
        onWillPop: onWillPop,
        color: color ?? SColorsLight().white,
        title: title,
        topPadding: MediaQuery.of(context).padding.top,
        bottomPadding: MediaQuery.of(sRouter.navigatorKey.currentContext!).padding.bottom,
        children: children,
      );
    },
  );
}
