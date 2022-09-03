import 'package:freezed_annotation/freezed_annotation.dart';

part 'encryption_key_response_model.freezed.dart';
part 'encryption_key_response_model.g.dart';

@freezed
class EncryptionKeyCardResponseModel with _$EncryptionKeyCardResponseModel {
  const factory EncryptionKeyCardResponseModel({
    required String keyId,
    required String key,
  }) = _EncryptionKeyCardResponseModel;

  factory EncryptionKeyCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EncryptionKeyCardResponseModelFromJson(json);
}
