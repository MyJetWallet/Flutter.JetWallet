import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/models/segment_control_data.dart';
import 'package:simple_kit_updated/widgets/navigation/segment_control/segment_control.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Segment control',
  type: Column,
)
Column simpleSegmentControlExample(BuildContext context) {
  return Column(
    children: [
      _SegmentControlDemo1(),
      const Gap(20),
      _SegmentControlDemo2(),
      const Gap(20),
      _SegmentControlDemo3(),
    ],
  );
}

class _SegmentControlDemo1 extends HookWidget {
  const _SegmentControlDemo1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return SegmentControl(
      tabController: tabController,
      expand: true,
      expandWidth: MediaQuery.of(context).size.width,
      items: [
        SegmentControlData(type: SegmentControlType.text, text: 'Label 1'),
        SegmentControlData(type: SegmentControlType.text, text: 'Label 2'),
      ],
    );
  }
}

class _SegmentControlDemo2 extends HookWidget {
  const _SegmentControlDemo2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3);

    return SegmentControl(
      tabController: tabController,
      items: [
        SegmentControlData(type: SegmentControlType.text, text: 'Label 1'),
        SegmentControlData(type: SegmentControlType.text, text: 'Label 2'),
        SegmentControlData(type: SegmentControlType.text, text: 'Label 2'),
      ],
    );
  }
}

class _SegmentControlDemo3 extends HookWidget {
  const _SegmentControlDemo3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 4);

    return SegmentControl(
      tabController: tabController,
      items: [
        SegmentControlData(type: SegmentControlType.iconText, text: 'Label 1'),
        SegmentControlData(type: SegmentControlType.icon, text: 'Label 2'),
        SegmentControlData(type: SegmentControlType.icon, text: 'Label 2'),
        SegmentControlData(type: SegmentControlType.icon, text: 'Label 2'),
      ],
    );
  }
}
