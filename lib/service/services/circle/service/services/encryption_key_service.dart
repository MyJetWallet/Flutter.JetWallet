import 'package:dio/dio.dart';

import '../../model/encryption_key/encryption_key_response_model.dart';

Future<EncryptionKeyResponseModel> encryptionKeyService(Dio dio) async {
  final response = await dio.get(
    'url',
  );

  final responseData = response.data as Map<String, dynamic>;

  return EncryptionKeyResponseModel.fromJson(responseData);
}
