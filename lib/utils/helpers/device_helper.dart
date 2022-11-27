import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:jetwallet/core/services/device_info/models/device_info_model.dart';
import 'package:jetwallet/core/services/device_size/models/device_size_union.dart';

String get deviceType {
  if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'ios';
  } else if (Platform.isFuchsia) {
    return 'fuchsia';
  } else if (Platform.isLinux) {
    return 'linux';
  } else if (Platform.isMacOS) {
    return 'macos';
  } else if (Platform.isWindows) {
    return 'windows';
  } else {
    return '';
  }
}

const _smallHeightBreakpoint = 800;

DeviceSizeUnion deviceSizeFrom(double screenHeight) {
  return screenHeight < _smallHeightBreakpoint
      ? const DeviceSizeUnion.small()
      : const DeviceSizeUnion.medium();
}

Future<DeviceInfoModel> deviceInfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceMarketingPlugin = DeviceMarketingNames();
  const _androidIdPlugin = AndroidId();
  final deviceMarketingName = await deviceMarketingPlugin.getSingleName();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    final andriudId = await _androidIdPlugin.getId();

    final deviceInfo = DeviceInfoModel(
      deviceUid: andriudId ?? '',
      osName: 'Android',
      version: androidInfo.version.release ?? '',
      sdk: androidInfo.version.sdkInt.toString(),
      manufacturer: androidInfo.manufacturer ?? '',
      model: androidInfo.model ?? '',
      marketingName: deviceMarketingName,
    );

    return deviceInfo;
  } else {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    final deviceInfo = DeviceInfoModel(
      deviceUid: iosInfo.identifierForVendor ?? '',
      osName: 'iOS',
      version: iosInfo.systemVersion ?? '',
      manufacturer: iosInfo.name ?? '',
      model: iosInfo.utsname.machine ?? '',
      marketingName: deviceMarketingName,
    );

    return deviceInfo;
  }
}
