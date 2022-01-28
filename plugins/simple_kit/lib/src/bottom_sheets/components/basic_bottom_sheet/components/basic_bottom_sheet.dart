import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../simple_kit.dart';
import 'bottom_sheet_bar.dart';

class BasicBottomSheet extends HookWidget {
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
  Widget build(BuildContext context) {
    var isAnimating = false;

    if (transitionAnimationController != null) {
      useListenable(transitionAnimationController!);
      isAnimating = transitionAnimationController!.isAnimating;
    }

    /// Needed to get the size of the pinned Widget
    final pinnedSize = useState<Size?>(Size.zero);
    final pinnedBottomSize = useState<Size?>(Size.zero);

    /// To avoid additional taps on barrier of bottom sheet when
    /// it was already tapped and bottom sheet is closing
    final isClosing = useState(false);

    void _onDissmisAction(BuildContext context) {
      if (!isClosing.value && !isAnimating) {
        isClosing.value = true;
        onDissmis?.call();
        Navigator.pop(context);
      }
    }

    return WillPopScope(
      onWillPop: onWillPop ??
          () {
            _onDissmisAction(context);
            return Future.value(true);
          },
      child: Padding(
        // Make bottomSheet to follow keyboard
        padding: MediaQuery.of(context).viewInsets,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final maxHeight = _listViewMaxHeight(
              maxHeight: constraints.maxHeight,
              pinnedSize: pinnedSize.value,
              pinnedBottomSize: pinnedBottomSize.value,
              removeBottomSheetBar: removeBottomSheetBar,
              removeBarPadding: removeBarPadding,
              removePinnedPadding: removePinnedPadding,
              pinnedBottom: pinnedBottom,
            );

            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onDissmisAction(context),
                  ),
                ),
                Material(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPinnedPadding ?? 24.0,
                        ),
                        child: Column(
                          children: [
                            if (!removeBottomSheetBar) ...[
                              const SpaceH8(),
                              const BottomSheetBar(),
                            ],
                            if (!removeBarPadding) const SpaceH24(),
                            if (pinned != null) ...[
                              SWidgetSize(
                                child: pinned!,
                                onChange: (size) {
                                  pinnedSize.value = size;
                                },
                              ),
                              if (!removePinnedPadding) const SpaceH24()
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 0,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: maxHeight,
                          minHeight: expanded ? maxHeight : minHeight ?? 0,
                        ),
                        child: ListView(
                          physics: scrollable
                              ? null
                              : const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: children,
                        ),
                      ),
                      if (pinnedBottom != null) ...[
                        SWidgetBottomSize(
                          child: pinnedBottom!,
                          onChange: (size) {
                            pinnedBottomSize.value = size;
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
