import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_size/models/device_size_union.dart';

const _smallHeightBreakpoint = 800;

final sDeviceSize = getIt.get<DeviceSize>().size;

DeviceSizeUnion deviceSizeFrom(double screenHeight) {
  return screenHeight < _smallHeightBreakpoint ? const DeviceSizeUnion.small() : const DeviceSizeUnion.medium();
}

@lazySingleton
class DeviceSize {
  late DeviceSizeUnion size;

  void setSize(double screenHeight) {
    size = deviceSizeFrom(screenHeight);
  }
}
