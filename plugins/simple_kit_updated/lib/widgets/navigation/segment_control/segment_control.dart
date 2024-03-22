import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/models/segment_control_data.dart';

class SegmentControl extends HookWidget {
  const SegmentControl({
    super.key,
    required this.tabController,
    required this.items,
    this.expand = false,
    this.expandWidth,
    this.shrinkWrap = false,
  });

  final TabController tabController;
  final List<SegmentControlData> items;
  final bool expand; // Если нужно растянуть по все ширине
  final double? expandWidth; // MediaQuery.of(context).size.width
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final baseRadius = BorderRadius.circular(16);

    useListenable(tabController);

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: SColorsLight().gray2,
        borderRadius: baseRadius,
      ),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            tabAlignment: TabAlignment.center,
            controller: tabController,
            indicator: BoxDecoration(
              color: SColorsLight().black,
              borderRadius: baseRadius,
            ),
            splashBorderRadius: baseRadius,
            enableFeedback: true,
            padding: EdgeInsets.zero,
            labelColor: SColorsLight().white,
            labelStyle: STStyles.subtitle2,
            unselectedLabelColor: SColorsLight().gray6,
            unselectedLabelStyle: STStyles.subtitle2,
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            indicatorWeight: 0,
            //dividerHeight: 0,
            dividerColor: Colors.transparent,
            isScrollable: true,
            tabs: items
                .mapIndexed(
                  (index, item) => Tab(
                    iconMargin: EdgeInsets.zero,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: expand ? ((expandWidth! / items.length) - 32) : shrinkWrap ? 0 : _getWidthBaseOnType(item),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        child: _getWidgetBaseOnType(item, index),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  double _getWidthBaseOnType(SegmentControlData e) {
    switch (e.type) {
      case SegmentControlType.iconText:
        return 111;
      case SegmentControlType.text:
        return 109;
      case SegmentControlType.icon:
        return 72;
    }
  }

  Widget _getWidgetBaseOnType(SegmentControlData e, int index) {
    switch (e.type) {
      case SegmentControlType.iconText:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            e.icon?.simpleSvg(
                  color: tabController.index == index ? SColorsLight().white : SColorsLight().gray6,
                  width: 16,
                  height: 16,
                ) ??
                Assets.svg.medium.add.simpleSvg(
                  color: tabController.index == index ? SColorsLight().white : SColorsLight().gray6,
                ),
            const Gap(8),
            Text(
              e.text ?? '',
              style: STStyles.subtitle2.copyWith(
                height: 0,
              ),
            ),
            const Gap(4),
          ],
        );
      case SegmentControlType.text:
        return Center(
          child: Text(
            e.text ?? '',
            style: STStyles.subtitle2.copyWith(
              height: 0,
            ),
          ),
        );
      case SegmentControlType.icon:
        return e.icon?.simpleSvg(
              color: tabController.index == index ? SColorsLight().white : SColorsLight().gray6,
              width: 16,
              height: 16,
            ) ??
            Assets.svg.medium.add.simpleSvg(
              color: tabController.index == index ? SColorsLight().white : SColorsLight().gray6,
            );
    }
  }
}
