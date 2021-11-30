import 'package:fast_rsa/fast_rsa.dart';

import 'local_storage_service.dart';

class RsaService {
  static const int _bits = 2048;

  late String publicKey;
  late String privateKey;

  Future<void> init() async {
    final key = await RSA.generate(_bits);

    publicKey = key.publicKey;
    privateKey = key.privateKey;
  }

  Future<void> savePrivateKey(
    LocalStorageService storageService,
  ) async {
    await storageService.setString(privateKeyKey, privateKey);
  }

  Future<String> sign(String text, String privateKey) async {
    return RSA.signPKCS1v15(text, Hash.SHA256, privateKey);
  }
}
