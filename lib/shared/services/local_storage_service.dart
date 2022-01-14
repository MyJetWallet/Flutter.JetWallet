import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// KEYS
const refreshTokenKey = 'refreshToken';
const userEmailKey = 'userEmail';
const privateKeyKey = 'privateKey';
const pinStatusKey = 'pinStatusKey';
const contactsPermissionKey = 'contactsPermissionKey';
const pinDisabledKey = 'pinDisabledKey';
const bannersIdsKey = 'bannersIds';
const phonebookStatusKey = 'phonebookStatusKey';
const cameraStatusKey = 'cameraStatusKey';
const referralCodeKey = 'referralCodeKey';

class LocalStorageService {
  final _storage = const FlutterSecureStorage();

  Future<String?> getString(String key) async {
    return _storage.read(key: key);
  }

  Future<void> setString(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> setJson(String key, List<String> json) async {
    await _storage.write(key: key, value: jsonEncode(json));
  }

  Future<String?> getJson(String key) async {
    return _storage.read(key: key);
  }

  Future<void> clearStorage() async {
    // Add keys you want to delete after logout or unsuccessful token refresh
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: userEmailKey);
    await _storage.delete(key: privateKeyKey);
    await _storage.delete(key: pinStatusKey);
    await _storage.delete(key: contactsPermissionKey);
    await _storage.delete(key: pinDisabledKey);
    await _storage.delete(key: bannersIdsKey);
    await _storage.delete(key: phonebookStatusKey);
  }
}
