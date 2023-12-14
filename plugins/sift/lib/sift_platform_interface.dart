import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sift_method_channel.dart';

abstract class SiftPlatform extends PlatformInterface {
  /// Constructs a SiftPlatform.
  SiftPlatform() : super(token: _token);

  static final Object _token = Object();

  static SiftPlatform _instance = MethodChannelSift();

  /// The default instance of [SiftPlatform] to use.
  ///
  /// Defaults to [MethodChannelSift].
  static SiftPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SiftPlatform] when
  /// they register themselves.
  static set instance(SiftPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> setUserID(String id) {
    throw UnimplementedError('setUserID() has not been implemented.');
  }

  Future<bool?> unsetUserID() {
    throw UnimplementedError('setUserID() has not been implemented.');
  }

  Future<String?> setSiftConfig({
    required String accountId,
    required String beaconKey,
  }) {
    throw UnimplementedError('setSiftConfig() has not been implemented.');
  }
}
