import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';

final packageInfoFpod = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});
