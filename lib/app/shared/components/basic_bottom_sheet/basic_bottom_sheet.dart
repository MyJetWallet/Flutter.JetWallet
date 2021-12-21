import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/bottom_sheet_bar.dart';

/// TODO (remove legacy code)
void showBasicBottomSheet({
  Widget? pinned,
  Function(dynamic)? then,
  Function()? onDissmis,
  double? minHeight,
  bool scrollable = false,
  Color color = Colors.white,
  required List<Widget> children,
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasicBottomSheet(
        color: color,
        pinned: pinned,
        minHeight: minHeight,
        onDissmis: onDissmis,
        scrollable: scrollable,
        children: children,
      );
    },
  ).then((value) => then != null ? then(value) : {});
}

class BasicBottomSheet extends StatelessWidget {
  const BasicBottomSheet({
    Key? key,
    this.pinned,
    this.onDissmis,
    this.minHeight,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  final Widget? pinned;
  final Function()? onDissmis;
  final double? minHeight;
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                const BottomSheetBar(),
                pinned ?? const SizedBox(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            constraints: BoxConstraints(
              maxHeight: 0.7.sh,
              minHeight: minHeight ?? 0,
            ),
            color: color,
            child: ListView(
              physics: scrollable ? null : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  void _onDissmisAction(BuildContext context) {
    if (onDissmis != null) {
      onDissmis!();
    } else {
      Navigator.pop(context);
    }
  }
}
