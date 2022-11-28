import 'package:jetwallet/core/services/device_size/models/device_size_union.dart';
import 'package:simple_kit/simple_kit.dart';

SWidgetSize widgetSizeFrom(DeviceSizeUnion union) {
  return union.when(
    small: () => SWidgetSize.small,
    medium: () => SWidgetSize.medium,
  );
}
