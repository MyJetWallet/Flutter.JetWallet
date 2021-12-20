import '../providers/device_size/device_size_union.dart';

const _smallScreenHeight = 667;

DeviceSizeUnion deviceSizeFrom(double screenHeight) {
  if (screenHeight <= _smallScreenHeight) {
    return const DeviceSizeUnion.small();
  } else if (screenHeight >= 667 && screenHeight <= 812) {
    return const DeviceSizeUnion.medium();
  } else {
    return const DeviceSizeUnion.medium();
  }
}
