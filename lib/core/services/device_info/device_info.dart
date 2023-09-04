import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:mobx/mobx.dart';

import '../local_storage_service.dart';

final sDeviceInfo = getIt.get<DeviceInfo>();

class DeviceInfo {
  final _deviceUid = Observable('');
  String get deviceUid => _deviceUid.value;
  set deviceUid(String newValue) => _deviceUid.value = newValue;

  final _osName = Observable('');
  String get osName => _osName.value;
  set osName(String newValue) => _osName.value = newValue;

  final _version = Observable('');
  String get version => _version.value;
  set version(String newValue) => _version.value = newValue;

  final _manufacturer = Observable('');
  String get manufacturer => _manufacturer.value;
  set manufacturer(String newValue) => _manufacturer.value = newValue;

  final _model = Observable('');
  String get model => _model.value;
  set model(String newValue) => _model.value = newValue;

  final _sdk = Observable('');
  String get sdk => _sdk.value;
  set sdk(String newValue) => _sdk.value = newValue;

  final _name = Observable('');
  String get name => _name.value;
  set name(String newValue) => _name.value = newValue;

  final _marketingName = Observable('');
  String get marketingName => _marketingName.value;
  set marketingName(String newValue) => _marketingName.value = newValue;

  Future<DeviceInfo> deviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceMarketingPlugin = DeviceMarketingNames();
    const androidIdPlugin = AndroidId();
    final deviceMarketingName = await deviceMarketingPlugin.getSingleName();
    final storageService = getIt.get<LocalStorageService>();
    final deviceIdUsed = await storageService.getValue(deviceId);

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      var andriudId = await androidIdPlugin.getId();
      if (deviceIdUsed != null) {
        andriudId = deviceIdUsed;
      } else {
        await storageService.setString(deviceId, andriudId);
      }

      deviceUid = andriudId ?? '';

      osName = 'Android';
      version = androidInfo.version.release;
      sdk = androidInfo.version.sdkInt.toString();
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      marketingName = deviceMarketingName;
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      var iosId = iosInfo.identifierForVendor;
      if (deviceIdUsed != null) {
        iosId = deviceIdUsed;
      } else {
        await storageService.setString(deviceId, iosId);
      }
      deviceUid = iosId ?? '';
      osName = 'iOS';
      version = iosInfo.systemVersion;
      manufacturer = iosInfo.name;
      model = iosInfo.utsname.machine;
      marketingName = deviceMarketingName;
    }

    return this;
  }
}
