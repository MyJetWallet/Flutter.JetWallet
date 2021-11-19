import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../simple_kit.dart';
import 'bottom_sheet_bar.dart';

class BasicBottomSheet extends HookWidget {
  const BasicBottomSheet({
    Key? key,
    this.pinned,
    this.onDissmis,
    this.maxHeight,
    this.minHeight,
    this.horizontalPadding,
    this.onWillPop,
    this.removeBottomSheetBar = false,
    this.horizontalPinnedPadding,
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
  final Future<bool> Function()? onWillPop;
  final bool removeBottomSheetBar;
  final bool removeBottomHeaderPadding;
  final Color color;
  final List<Widget> children;
  final bool scrollable;
  final double? horizontalPinnedPadding;

  @override
  Widget build(BuildContext context) {
    /// To avoid additional taps on barrier of bottom sheet when
    /// it was already tapped and bottom sheet is closing
    final isClosing = useState(false);

    void _onDissmisAction(BuildContext context) {
      if (!isClosing.value) {
        onDissmis?.call();
        Navigator.pop(context);
        isClosing.value = true;
      }
    }

    return WillPopScope(
      onWillPop: onWillPop ??
          () {
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
                    horizontal: horizontalPinnedPadding ?? 24.w,
                  ),
                  child: Column(
                    children: [
                      if (!removeBottomSheetBar) ...[
                        const SpaceH8(),
                        const BottomSheetBar(),
                      ],
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
}
