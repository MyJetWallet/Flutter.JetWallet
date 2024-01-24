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
      SegmentControlDemo1(),
      const Gap(20),
      SegmentControlDemo2(),
      const Gap(20),
      SegmentControlDemo3(),
    ],
  );
}

class SegmentControlDemo1 extends HookWidget {
  const SegmentControlDemo1({Key? key}) : super(key: key);

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

class SegmentControlDemo2 extends HookWidget {
  const SegmentControlDemo2({Key? key}) : super(key: key);

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

class SegmentControlDemo3 extends HookWidget {
  const SegmentControlDemo3({Key? key}) : super(key: key);

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
