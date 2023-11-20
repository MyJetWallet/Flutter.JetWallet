import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

import 'local_storage_service.dart';

@lazySingleton
class RsaService {
  late String publicKey;
  late String privateKey;

  void init() {
    final rsa = RsaKeyHelper();
    final keyPair = getRsaKeyPair(rsa.getSecureRandom());

    final rsaPublicKey = keyPair.publicKey as RSAPublicKey;
    final rsaPrivateKey = keyPair.privateKey as RSAPrivateKey;

    publicKey = rsa.encodePublicKeyToPemPKCS1(rsaPublicKey);
    privateKey = rsa.encodePrivateKeyToPemPKCS1(rsaPrivateKey);
  }

  String sign(String text, String privateKey) {
    final rsa = RsaKeyHelper();

    final key = rsa.parsePrivateKeyFromPem(privateKey);

    return rsa.sign(text, key);
  }

  Future<void> savePrivateKey(LocalStorageService storageService) async {
    log(privateKey);
    await storageService.setString(privateKeyKey, privateKey);
  }
}
