import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sift_platform_interface.dart';

/// An implementation of [SiftPlatform] that uses method channels.
class MethodChannelSift extends SiftPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sift');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> setUserID(String id) async {
    final version = await methodChannel.invokeMethod('setUserID', {'id': id});
    return version;
  }

  @override
  Future<bool?> unsetUserID() async {
    final version = await methodChannel.invokeMethod('unsetUserID');
    return version;
  }

  @override
  Future<String?> setSiftConfig({
    required String accountId,
    required String beaconKey,
  }) async {
    final version = await methodChannel.invokeMethod(
      'setSiftConfig',
      {'accountId': accountId, 'beaconKey': beaconKey},
    );
    return version;
  }
}
