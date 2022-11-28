import 'package:flutter/material.dart';
import 'package:simple_kit/modules/shared/simple_get_widget_size.dart';
import 'package:simple_kit/modules/shared/simple_widget_bottom_size.dart';
import 'package:simple_kit/simple_kit.dart';

import 'bottom_sheet_bar.dart';

class BasicBottomSheet extends StatefulWidget {
  const BasicBottomSheet({
    Key? key,
    this.transitionAnimationController,
    this.pinned,
    this.onDissmis,
    this.minHeight,
    this.horizontalPadding,
    this.onWillPop,
    this.horizontalPinnedPadding,
    this.pinnedBottom,
    this.expanded = false,
    this.removeBottomSheetBar = false,
    this.removeBarPadding = false,
    this.removePinnedPadding = false,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  // In case if BottomSheet can be closed from outside of its scope
  // then transitionAnimationController parameter must be provided
  // to listen for isAnimating parameter
  final AnimationController? transitionAnimationController;
  final Widget? pinned;
  final Widget? pinnedBottom;
  final Function()? onDissmis;
  final double? minHeight;
  final double? horizontalPadding;
  final Future<bool> Function()? onWillPop;
  final bool expanded;
  final bool removeBottomSheetBar;
  final bool removeBarPadding;
  final bool removePinnedPadding;
  final Color color;
  final List<Widget> children;
  final bool scrollable;
  final double? horizontalPinnedPadding;

  @override
  State<BasicBottomSheet> createState() => _BasicBottomSheetState();
}

class _BasicBottomSheetState extends State<BasicBottomSheet> {
  void transitionListener() {}

  bool isAnimating = false;

  /// To avoid additional taps on barrier of bottom sheet when
  /// it was already tapped and bottom sheet is closing
  bool isClosing = false;

  /// Needed to get the size of the pinned Widget
  Size? pinnedSize = Size.zero;
  Size? pinnedBottomSize = Size.zero;

  @override
  void initState() {
    if (widget.transitionAnimationController != null) {
      widget.transitionAnimationController!.addListener(transitionListener);
      isAnimating = widget.transitionAnimationController!.isAnimating;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.transitionAnimationController != null) {
      widget.transitionAnimationController!.removeListener(transitionListener);
      isAnimating = widget.transitionAnimationController!.isAnimating;
    }
    super.dispose();
  }

  void onDissmisAction(BuildContext context) {
    if (!isClosing) {
      setState(() {
        isClosing = true;
      });
      widget.onDissmis?.call();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.onWillPop ??
          () {
            onDissmisAction(context);

            return Future.value(true);
          },
      child: Padding(
        // Make bottomSheet to follow keyboard
        padding: MediaQuery.of(context).viewInsets,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final maxHeight = _listViewMaxHeight(
              maxHeight: constraints.maxHeight,
              pinnedSize: pinnedSize,
              pinnedBottomSize: pinnedBottomSize,
              removeBottomSheetBar: widget.removeBottomSheetBar,
              removeBarPadding: widget.removeBarPadding,
              removePinnedPadding: widget.removePinnedPadding,
              pinnedBottom: widget.pinnedBottom,
            );

            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onDissmisAction(context),
                  ),
                ),
                Material(
                  color: widget.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPinnedPadding ?? 24.0,
                        ),
                        child: Column(
                          children: [
                            if (!widget.removeBottomSheetBar) ...[
                              const SpaceH8(),
                              const BottomSheetBar(),
                            ],
                            if (!widget.removeBarPadding) const SpaceH24(),
                            if (widget.pinned != null) ...[
                              SGetWidgetSize(
                                child: widget.pinned!,
                                onChange: (size) {
                                  setState(() {
                                    pinnedSize = size;
                                  });
                                },
                              ),
                              if (!widget.removePinnedPadding) const SpaceH24(),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPadding ?? 0,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: maxHeight,
                          minHeight: widget.expanded
                              ? maxHeight
                              : widget.minHeight ?? 0,
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: widget.scrollable
                              ? null
                              : const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: widget.children,
                        ),
                      ),
                      if (widget.pinnedBottom != null) ...[
                        SWidgetBottomSize(
                          child: widget.pinnedBottom!,
                          onChange: (size) {
                            setState(() {
                              pinnedBottomSize = size;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

double _listViewMaxHeight({
  required double maxHeight,
  required bool removeBottomSheetBar,
  required bool removeBarPadding,
  required bool removePinnedPadding,
  required Size? pinnedSize,
  required Size? pinnedBottomSize,
  required Widget? pinnedBottom,
}) {
  var max = maxHeight;

  if (!removeBottomSheetBar) {
    max = max - 8 - 4; // BottomSheetSpace + BottomSheetBarHeight
  }

  if (!removeBarPadding) {
    max = max - 24;
  }

  if (pinnedSize != null) {
    max = max - pinnedSize.height;

    if (!removePinnedPadding) {
      max = max - 24;
    }
  }

  if (pinnedBottomSize != null) {
    max = max - pinnedBottomSize.height;
  }

  return max - 60; // required spacing from the top edge of the device;
}
