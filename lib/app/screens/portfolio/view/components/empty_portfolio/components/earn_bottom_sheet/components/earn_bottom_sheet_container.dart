import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../market/view/components/change_on_scroll.dart';

class EarnBottomSheetContainer extends StatefulWidget {
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
  _EarnBottomSheetContainerState createState() =>
      _EarnBottomSheetContainerState();
}

class _EarnBottomSheetContainerState extends State<EarnBottomSheetContainer> {
  late double _offset;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _offset = 0;
    controller.addListener(_setOffset);
  }

  @override
  void dispose() {
    controller.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    if (controller.hasClients) {
      setState(() {
        _offset = controller.offset;
      });
    }
  }

  bool _needToHideOutWidget(ScrollController controller) {
    return (widget.expandedHeight - 115) < _offset;
  }

  @override
  Widget build(BuildContext context) {

    // final isClosing = useState(false);

    void _onDissmisAction(BuildContext context) {
      // if (!isClosing.value) {
      //   isClosing.value = true;
        widget.onDissmis?.call();
        Navigator.pop(context);
      // }
    }

    return WillPopScope(
        onWillPop: () {
          _onDissmisAction(context);
          return Future.value(true);
        },
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: LayoutBuilder(
            builder: (_, constraints) {
              final maxHeight = _listViewMaxHeight(
                maxHeight: constraints.maxHeight,
                removePinnedPadding: widget.removePinnedPadding,
                pinnedBottom: widget.pinnedBottom,
              );

              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onDissmisAction(context),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.horizontalPadding ?? 0,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: maxHeight,
                            minHeight: widget.expanded
                                ? maxHeight
                                : widget.minHeight ?? 0,
                          ),
                          child: CustomScrollView(
                            controller: controller,
                            slivers: [
                              SliverAppBar(
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.transparent,
                                pinned: _needToHideOutWidget(controller),
                                elevation: 0,
                                expandedHeight: widget.expandedHeight,
                                collapsedHeight: 115,
                                primary: false,
                                flexibleSpace: ChangeOnScroll(
                                  scrollController: controller,
                                  fullOpacityOffset: widget.expandedHeight -
                                      115,
                                  changeInWidget: Material(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24.0),
                                      topRight: Radius.circular(24.0),
                                    ),
                                    child: widget.pinnedSmall,
                                  ),
                                  changeOutWidget: widget.pinned,
                                  permanentWidget: const SpaceW2(),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // widget.pinned,
                                    // const SpaceH30(),
                                    ...widget.children,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.pinnedBottom != null) ...[
                          widget.pinnedBottom!
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
  required bool removePinnedPadding,
  required Widget? pinnedBottom,
}) {
  var max = maxHeight;

  if (pinnedBottom != null) {
    max = max - 105;
  }

  return max - 60; // required spacing from the top edge of the device;
}
