import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_info/models/device_info_model.dart';

import '../local_storage_service.dart';

final sDeviceInfo = getIt.get<DeviceInfo>();

class DeviceInfo {
  late DeviceInfoModel model;

  Future<DeviceInfo> deviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceMarketingPlugin = DeviceMarketingNames();
    const _androidIdPlugin = AndroidId();
    final deviceMarketingName = await deviceMarketingPlugin.getSingleName();
    final storageService = getIt.get<LocalStorageService>();
    final deviceIdUsed = await storageService.getValue(deviceId);

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      var andriudId = await _androidIdPlugin.getId();
      if (deviceIdUsed != null) {
        andriudId = deviceIdUsed;
      } else {
        await storageService.setString(deviceId, andriudId);
      }

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
      var iosId = iosInfo.identifierForVendor;
      if (deviceIdUsed != null) {
        iosId = deviceIdUsed;
      } else {
        await storageService.setString(deviceId, iosId);
      }
      final deviceInfo = DeviceInfoModel(
        deviceUid: iosId ?? '',
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
