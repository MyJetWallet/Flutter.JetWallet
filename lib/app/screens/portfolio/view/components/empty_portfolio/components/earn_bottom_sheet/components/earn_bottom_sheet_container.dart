import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:simple_kit/simple_kit.dart';

class EarnBottomSheetContainer extends HookWidget {
  const EarnBottomSheetContainer({
    Key? key,
    this.pinned,
    this.pinnedSmall,
    this.onDissmis,
    this.minHeight,
    this.horizontalPadding,
    this.horizontalPinnedPadding,
    this.expanded = false,
    this.removePinnedPadding = false,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  final Widget? pinned;
  final Widget? pinnedSmall;
  final Function()? onDissmis;
  final double? minHeight;
  final double? horizontalPadding;
  final bool expanded;
  final bool removePinnedPadding;
  final Color color;
  final List<Widget> children;
  final bool scrollable;
  final double? horizontalPinnedPadding;

  @override
  Widget build(BuildContext context) {

    /// Needed to get the size of the pinned Widget
    final pinnedSize = useState<Size?>(Size.zero);
    final pinnedSmallSize = useState<Size?>(Size.zero);

    final isClosing = useState(false);

    void _onDissmisAction(BuildContext context) {
      if (!isClosing.value) {
        isClosing.value = true;
        onDissmis?.call();
        Navigator.pop(context);
      }
    }

    return WillPopScope(
      onWillPop: () {
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
              pinnedSmallSize: pinnedSmallSize.value,
              removePinnedPadding: removePinnedPadding,
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
                            if (pinned != null) ...[
                              SGetWidgetSize(
                                child: pinned!,
                                onChange: (size) {
                                  pinnedSize.value = size;
                                },
                              ),
                              if (!removePinnedPadding) const SpaceH24()
                            ],
                            if (pinnedSmall != null) ...[
                              SGetWidgetSize(
                                child: pinnedSmall!,
                                onChange: (size) {
                                  pinnedSmallSize.value = size;
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
  required bool removePinnedPadding,
  required Size? pinnedSize,
  required Size? pinnedSmallSize,
}) {
  var max = maxHeight;

  if (pinnedSize != null) {
    max = max - pinnedSize.height;

    if (!removePinnedPadding) {
      max = max - 24;
    }
  }

  if (pinnedSmallSize != null) {
    max = max - pinnedSmallSize.height;

    if (!removePinnedPadding) {
      max = max - 24;
    }
  }

  return max - 60; // required spacing from the top edge of the device;
}
