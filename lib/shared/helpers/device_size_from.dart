import '../providers/device_size/device_size_union.dart';

const _smallHeightBreakpoint = 800;

DeviceSizeUnion deviceSizeFrom(double screenHeight) {
  if (screenHeight < _smallHeightBreakpoint) {
    return const DeviceSizeUnion.small();
  } else {
    return const DeviceSizeUnion.medium();
  }
}
