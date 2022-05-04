import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../market/view/components/change_on_scroll.dart';
import '../../../../../../../market/view/components/fade_on_scroll.dart';

class EarnBottomSheetContainer extends HookWidget {
  const EarnBottomSheetContainer({
    Key? key,
    this.onDissmis,
    this.minHeight,
    this.horizontalPadding,
    this.horizontalPinnedPadding,
    this.expanded = false,
    this.removePinnedPadding = false,
    this.pinnedBottom,
    required this.expandedHeight,
    required this.pinned,
    required this.pinnedSmall,
    required this.color,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  final Widget pinned;
  final Widget pinnedSmall;
  final Widget? pinnedBottom;
  final Function()? onDissmis;
  final double? minHeight;
  final double? horizontalPadding;
  final double expandedHeight;
  final bool expanded;
  final bool removePinnedPadding;
  final Color color;
  final List<Widget> children;
  final bool scrollable;
  final double? horizontalPinnedPadding;

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    /// Needed to get the size of the pinned Widget
    final pinnedSize = useState<Size?>(Size.zero);
    final pinnedSmallSize = useState<Size?>(Size.zero);
    final pinnedBottomSize = useState<Size?>(Size.zero);

    final isClosing = useState(false);

    void _onDissmisAction(BuildContext context) {
      if (!isClosing.value) {
        isClosing.value = true;
        onDissmis?.call();
        Navigator.pop(context);
      }
    }

    return Padding(
        // Make bottomSheet to follow keyboard
        padding: MediaQuery.of(context).viewInsets,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final maxHeight = _listViewMaxHeight(
              maxHeight: constraints.maxHeight,
              pinnedSize: pinnedSize.value,
              pinnedSmallSize: pinnedSmallSize.value,
              removePinnedPadding: removePinnedPadding,
              pinnedBottom: pinnedBottom,
              pinnedBottomSize: pinnedBottomSize.value,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 0,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: maxHeight,
                          minHeight: expanded
                              ? maxHeight
                              : minHeight ?? 0,
                        ),
                        child: NestedScrollView(
                          controller: controller,
                          headerSliverBuilder: (context, _) {
                            return [
                              ChangeOnScroll(
                                scrollController: controller,
                                fullOpacityOffset: expandedHeight,
                                changeInWidget: Material(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(24.0),
                                    topRight: Radius.circular(24.0),
                                  ),
                                  child: pinnedSmall,
                                ),
                                changeOutWidget: pinned,
                                permanentWidget: const SpaceW2(),
                              ),
                            ];
                          },
                          body: ListView(
                            physics: scrollable
                                ? null
                                : const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              // pinned,
                              ...children
                            ],
                          ),
                        ),
                      ),
                      if (pinnedBottom != null) ...[
                        pinnedBottom!
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
  }
}

double _listViewMaxHeight({
  required double maxHeight,
  required bool removePinnedPadding,
  required Size? pinnedSize,
  required Size? pinnedSmallSize,
  required Size? pinnedBottomSize,
  required Widget? pinnedBottom,
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

  if (pinnedBottom != null) {
    max = max - 105;
  }

  return max - 60; // required spacing from the top edge of the device;
}
