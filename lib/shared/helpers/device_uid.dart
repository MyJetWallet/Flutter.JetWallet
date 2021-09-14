import 'package:device_info_plus/device_info_plus.dart';
import 'package:universal_io/io.dart';

Future<String?> deviceUid() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      final build = await deviceInfoPlugin.androidInfo;
      return build.androidId;
    } else if (Platform.isIOS) {
      final data = await deviceInfoPlugin.iosInfo;
      return data.identifierForVendor;
    }
  } catch (e) {
    return null;
  }
}
