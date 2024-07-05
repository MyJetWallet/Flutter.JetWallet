import 'package:freezed_annotation/freezed_annotation.dart';

part 'encryption_key_response_model.freezed.dart';
part 'encryption_key_response_model.g.dart';

@freezed
class EncryptionKeyResponseModel with _$EncryptionKeyResponseModel {
  const factory EncryptionKeyResponseModel({
    required String keyId,
    required String encryptionKey,
  }) = _EncryptionKeyResponseModel;

  factory EncryptionKeyResponseModel.fromJson(Map<String, dynamic> json) => _$EncryptionKeyResponseModelFromJson(json);
}
