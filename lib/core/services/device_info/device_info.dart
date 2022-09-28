import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_info/models/device_info_model.dart';

final sDeviceInfo = getIt.get<DeviceInfo>();

class DeviceInfo {
  late DeviceInfoModel model;

  Future<DeviceInfo> deviceInfo() async {
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
      model = deviceInfo;
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
      model = deviceInfo;
    }

    return this;
  }
}
