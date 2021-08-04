import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/bottom_sheet_bar.dart';

void showBasicBottomSheet({
  Widget? pinned,
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
      return _BasicBottomSheet(
        color: color,
        pinned: pinned,
        scrollable: scrollable,
        children: children,
      );
    },
  );
}

class _BasicBottomSheet extends StatelessWidget {
  const _BasicBottomSheet({
    Key? key,
    this.pinned,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  final Widget? pinned;
  final Color color;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          width: double.infinity,
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
          ),
          color: color,
          child: ListView(
            physics: scrollable ? null : const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: children,
          ),
        ),
      ],
    );
  }
}
