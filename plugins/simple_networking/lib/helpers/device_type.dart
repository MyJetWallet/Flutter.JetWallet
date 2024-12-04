import 'dart:io';

String get deviceType {
  // if (bool.fromEnvironment('dart.library.js_util')) {
    return 'web';
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
    return 'web';
  }
}
