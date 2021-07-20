import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/action_sheet_bar.dart';
import 'components/action_sheet_button.dart';

void showActionBottomSheet({
  required double sheetheight,
  required BuildContext context,
  required List<ActionSheetButton> children,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ActionSheet(
      sheetheight: sheetheight,
      children: children,
    ),
  );
}

class ActionSheet extends StatelessWidget {
  const ActionSheet({
    Key? key,
    required this.sheetheight,
    required this.children,
  }) : super(key: key);

  final double sheetheight;
  final List<ActionSheetButton> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sheetheight + 0.04.sh,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const ActionSheetBar(),
          Container(
            height: sheetheight,
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
              vertical: 30.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
