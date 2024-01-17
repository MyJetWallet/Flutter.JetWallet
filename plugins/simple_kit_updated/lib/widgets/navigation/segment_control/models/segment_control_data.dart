import 'package:simple_kit_updated/gen/assets.gen.dart';

enum SegmentControlType { text, icon, iconText }

class SegmentControlData {
  SegmentControlData({
    required this.type,
    this.text,
    this.icon,
  });

  SegmentControlType type;
  String? text;
  SvgGenImage? icon;
}
