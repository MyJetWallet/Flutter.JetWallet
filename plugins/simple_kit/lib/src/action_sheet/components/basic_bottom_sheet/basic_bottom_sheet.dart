import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';
import 'components/bottom_sheet_bar.dart';

void showBasicBottomSheet({
  Widget? pinned,
  Function(dynamic)? then,
  Function()? onDissmis,
  double? maxHeight,
  double? minHeight,
  Color? color,
  double? horizontalPadding,
  bool removeBottomHeaderPadding = false,
  bool scrollable = false,
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
        onDissmis: onDissmis,
        maxHeight: maxHeight,
        minHeight: minHeight,
        horizontalPadding: horizontalPadding,
        removeBottomHeaderPadding: removeBottomHeaderPadding,
        scrollable: scrollable,
        children: children,
      );
    },
  ).then((value) => then?.call(value));
}

class BasicBottomSheet extends StatelessWidget {
  const BasicBottomSheet({
    Key? key,
    this.pinned,
    this.onDissmis,
    this.maxHeight,
    this.minHeight,
    this.horizontalPadding,
    required this.removeBottomHeaderPadding,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  final Widget? pinned;
  final Function()? onDissmis;
  final double? maxHeight;
  final double? minHeight;
  final double? horizontalPadding;
  final bool removeBottomHeaderPadding;
  final Color color;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onDissmisAction(context);
        return Future.value(true);
      },
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _onDissmisAction(context),
            ),
          ),
          Material(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                  ),
                  child: Column(
                    children: [
                      const SpaceH8(),
                      const BottomSheetBar(),
                      const SpaceH24(),
                      pinned ?? const SizedBox(),
                      if (!removeBottomHeaderPadding) const SpaceH24()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding ?? 0,
                  ),
                  constraints: BoxConstraints(
                    maxHeight: maxHeight ?? 0.7.sh,
                    minHeight: minHeight ?? 0,
                  ),
                  child: ListView(
                    physics: scrollable
                        ? null
                        : const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDissmisAction(BuildContext context) {
    onDissmis?.call();
    Navigator.pop(context);
  }
}
