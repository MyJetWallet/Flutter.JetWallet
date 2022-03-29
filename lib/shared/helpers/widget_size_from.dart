import 'package:simple_kit/simple_kit.dart';

import '../providers/device_size/device_size_union.dart';

SWidgetSize widgetSizeFrom(DeviceSizeUnion union) {
  return union.when(
    small: () => SWidgetSize.small,
    medium: () => SWidgetSize.medium,
  );
}
