import 'dart:io';

String get deviceType {
  if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'ios';
  } else {
    return '';
  }
}
