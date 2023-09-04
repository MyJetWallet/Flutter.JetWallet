import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';

Future<RequestOptions> setHeaders(RequestOptions options, bool isImage) async {
  final locale = intl.localeName;
  final deviceInfo = getIt.get<DeviceInfo>();

  options.headers['accept'] = 'application/json';
  options.headers['Accept-Language'] = locale;
  options.headers['From'] = deviceInfo.deviceUid;
  options.headers['User-Agent'] = await getUserAgent();

  if (isImage) {
    options.headers['Content-Type'] = 'multipart/form-data';
  } else {
    options.headers['content-Type'] = 'application/json';
  }

  return options;
}
