import 'package:jetwallet/core/services/device_size/models/device_size_union.dart';

enum SWidgetSize {
  small,
  medium,
}

SWidgetSize widgetSizeFrom(DeviceSizeUnion union) {
  return union.when(
    small: () => SWidgetSize.small,
    medium: () => SWidgetSize.medium,
  );
}
