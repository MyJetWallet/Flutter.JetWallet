import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:universal_io/io.dart';

import '../model/device_info/device_info_model.dart';

Future<DeviceInfoModel> deviceInfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceMarketingPlugin = DeviceMarketingNames();
  final deviceMarketingName = await deviceMarketingPlugin.getSingleName();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    final deviceInfo = DeviceInfoModel(
      deviceUid: androidInfo.androidId ?? '',
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
