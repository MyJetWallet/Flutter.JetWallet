import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// KEYS
const refreshTokenKey = 'refreshToken';
const userEmailKey = 'userEmail';
const privateKeyKey = 'privateKey';
const pinStatusKey = 'pinStatusKey';
const contactsPermissionKey = 'contactsPermissionKey';
const pinDisabledKey = 'pinDisabledKey';

class LocalStorageService {
  final _storage = const FlutterSecureStorage();

  Future<String?> getString(String key) async {
    return _storage.read(key: key);
  }

  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> setStringArray(String key, List<String> value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  Future<String?> getStringArray(String key) async {
    return _storage.read(key: key);
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }
}
