import 'sift_platform_interface.dart';

class Sift {
  Future<String?> getPlatformVersion() {
    return SiftPlatform.instance.getPlatformVersion();
  }

  Future<bool?> setUserID(String id) {
    return SiftPlatform.instance.setUserID(id);
  }

  Future<bool?> unsetUserID() {
    return SiftPlatform.instance.unsetUserID();
  }

  Future<String?> setSiftConfig({
    required String accountId,
    required String beaconKey,
  }) {
    return SiftPlatform.instance.setSiftConfig(
      accountId: accountId,
      beaconKey: beaconKey,
    );
  }
}
