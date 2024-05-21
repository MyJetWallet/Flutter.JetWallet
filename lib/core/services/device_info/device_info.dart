import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../local_storage_service.dart';

final sDeviceInfo = getIt.get<DeviceInfo>();

class DeviceInfo {
  static final _deviceUid = Observable('Fake_deviceUid');
  String get deviceUid => _deviceUid.value;
  set deviceUid(String newValue) => _deviceUid.value = newValue;

  static final _osName = Observable('Fake_osName');
  String get osName => _osName.value;
  set osName(String newValue) => _osName.value = newValue;

  static final _version = Observable('Fake_version');
  String get version => _version.value;
  set version(String newValue) => _version.value = newValue;

  static final _manufacturer = Observable('Fake_manufacturer');
  String get manufacturer => _manufacturer.value;
  set manufacturer(String newValue) => _manufacturer.value = newValue;

  static final _model = Observable('Fake_model');
  String get model => _model.value;
  set model(String newValue) => _model.value = newValue;

  static final _sdk = Observable('Fake_sdk');
  String get sdk => _sdk.value;
  set sdk(String newValue) => _sdk.value = newValue;

  static final _name = Observable('Fake_name');
  String get name => _name.value;
  set name(String newValue) => _name.value = newValue;

  static final _marketingName = Observable('Fake_marketingName');
  String get marketingName => _marketingName.value;
  set marketingName(String newValue) => _marketingName.value = newValue;

  Future<DeviceInfo> deviceInfo() async {
    try {
      throw Exception('Feeeeeeeeeeeeeiiiiiiiiiil');
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
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'DeviceInfo',
            message: e.toString(),
          );

      await handlingIncorrectDeviceId();

      return DeviceInfo();
    }
  }

  Future<void> handlingIncorrectDeviceId() async {
    try {
      if (deviceUid == 'Fake_deviceUid') {
        final storage = sLocalStorageService;

        final localDeviceId = await sLocalStorageService.getValue(spareDeviceId);

        if (localDeviceId != null) {
          deviceUid = localDeviceId;
        } else {
          const uuid = Uuid();
          deviceUid = 'fake_${uuid.v4()}';
          await storage.setString(
            spareDeviceId,
            deviceUid,
          );
        }
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'DeviceInfo',
            message: e.toString(),
          );
    }
  }
}
