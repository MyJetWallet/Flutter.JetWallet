import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/bottom_sheet_bar.dart';

void showBasicBottomSheet({
  Widget? pinned,
  Function(dynamic)? then,
  Function()? onDissmis,
  String? header,
  double? maxHeight,
  double? minHeight,
  double? horizontalPadding,
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
        onDissmis: onDissmis,
        header: header,
        maxHeight: maxHeight,
        minHeight: minHeight,
        horizontalPadding: horizontalPadding,
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
    this.header,
    this.maxHeight,
    this.minHeight,
    this.horizontalPadding,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  final Widget? pinned;
  final Function()? onDissmis;
  final String? header;
  final double? maxHeight;
  final double? minHeight;
  final double? horizontalPadding;
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
                if (header != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
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
                    horizontal: horizontalPadding ?? 24.w,
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
