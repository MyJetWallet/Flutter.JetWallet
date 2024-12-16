import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

Future<T?> showBasicBottomSheet<T>({
  required BuildContext context,
  required List<Widget> children,
  BasicBottomSheetHeaderWidget header = const BasicBottomSheetHeaderWidget(),
  Widget? button,
  Function()? onDismiss,
  bool isDismissible = true,
  Future Function(bool)? onWillPop,
  Color? color,
  String? title,
  bool expanded = false,
}) async {
  final topPadding = MediaQuery.of(context).padding.top;
  final bottomPadding = MediaQuery.of(sRouter.navigatorKey.currentContext ?? context).padding.bottom;

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return BasicBottomSheet(
        header: header,
        button: button,
        onDismiss: onDismiss,
        onWillPop: onWillPop,
        color: color ?? SColorsLight().white,
        title: title,
        expanded: expanded,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        children: children,
      );
    },
  );
}
